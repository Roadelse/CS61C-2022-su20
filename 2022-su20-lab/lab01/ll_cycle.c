#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    if (!head) {return 0;}
    node *t = head, *h = head;

    while (1){
        t = t->next;
        if (!t) {break;}
        t = t->next;
        if (!t) {break;}
        h = h->next;

        if (t == h) {return 1;}
    }
          
    
    return 0;
}
