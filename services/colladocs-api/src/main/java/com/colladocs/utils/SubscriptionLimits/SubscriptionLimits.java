package com.colladocs.utils.SubscriptionLimits;

public class SubscriptionLimits {
    private int maxDocuments;
    private int maxDocumentSize;

    public SubscriptionLimits(int maxDocuments, int maxDocumentSize) {
        this.maxDocuments = maxDocuments;
        this.maxDocumentSize = maxDocumentSize;
    }

    public int getMaxDocuments() {
        return maxDocuments;
    }

    public int getMaxDocumentSize() {
        return maxDocumentSize;
    }
}
