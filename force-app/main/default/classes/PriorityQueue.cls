public class PriorityQueue {
    List<Representative__c> repHeap;

    // constructor
    public PriorityQueue() {
        this.repHeap = new List<Representative__c>();
    }

    // Add representative to queue based on their score
    public void enqueue(Representative__c rep) {
        // insert at end of list and sift up
        System.debug('::enqueue::');
        System.debug('::rep::'+rep);
        this.repHeap.add(rep);
        System.debug('::repHeap.size()::'+this.repHeap.size());
        this.siftUp(this.repHeap.size() - 1);
    }

    // Remove and return representative with highest score
    public Representative__c dequeue() {
        // swap first and last element and sift down from first
        System.debug('::dequeue::');
        Representative__c highestScoreRep = this.repHeap[0];
        this.swap(0, this.repHeap.size() - 1);
        this.repHeap.remove(this.repHeap.size() - 1);
        this.siftDown(0);
        return highestScoreRep;
    }
     private void siftUp(Integer index) {
        System.debug('siftUp::index::'+index);
        Integer parentIndex = (index - 1) / 2;
        System.debug('parentIndex::'+parentIndex);
       	System.debug('index::'+index);
        System.debug('this.repHeap[parentIndex].Score__c::'+this.repHeap[parentIndex].Score__c);
        System.debug('this.repHeap[index].Score__c:'+this.repHeap[index].Score__c);
        if (parentIndex >= 0 && this.repHeap[parentIndex].Score__c < this.repHeap[index].Score__c) {
            this.swap(parentIndex, index);
            this.siftUp(parentIndex);
        }
        System.debug('After function call index::'+index);
    }

    private void siftDown(Integer index) {
        System.debug('::siftDown::');
        System.debug('siftDown::'+index);
        Integer leftChildIndex = 2 * index + 1;
        System.debug('leftChildIndex::'+leftChildIndex);
        Integer rightChildIndex = 2 * index + 2;
        System.debug('rightChildIndex::'+rightChildIndex);
        Integer largestIndex = index;
        System.debug('largestIndex::'+largestIndex);

        if (leftChildIndex < this.repHeap.size() && this.repHeap[leftChildIndex].Score__c > this.repHeap[largestIndex].Score__c) {
            System.debug('leftChildIndex::'+leftChildIndex);
            largestIndex = leftChildIndex;
            System.debug('If::largestIndex::'+largestIndex);
        }

        if (rightChildIndex < this.repHeap.size() && this.repHeap[rightChildIndex].Score__c > this.repHeap[largestIndex].Score__c) {
            System.debug('rightChildIndex::'+rightChildIndex);
            largestIndex = rightChildIndex;
            System.debug('If::largestIndex::'+largestIndex);
        }
		System.debug('if::largestIndex::'+largestIndex);
        System.debug('if::largestIndex::index::'+index);
        if (largestIndex != index) {
            this.swap(largestIndex, index);
            this.siftDown(largestIndex);
        }
    }

    private void swap(Integer index1, Integer index2) {
        System.debug('::swap::');
        System.debug('swap::index::'+index1);
        System.debug('swap::index2::'+index2);
        Representative__c temp = this.repHeap[index1];
        this.repHeap[index1] = this.repHeap[index2];
        System.debug('this.repHeap[index1]:'+this.repHeap[index1]);
        System.debug('temp::'+temp);
        this.repHeap[index2] = temp;
        System.debug(' this.repHeap[index2]:'+ this.repHeap[index2]);
    }
    
    private void swapLeft(Integer index1, Integer Index2){
        Representative__c temp = new Representative__c();
        this.repHeap[Index1] = this.repHeap[Index1];
        this.repHeap[index2] = temp;
        System.debug('Index::'+Index2);     
    }
}