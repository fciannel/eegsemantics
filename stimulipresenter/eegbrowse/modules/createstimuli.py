import os
import random
from random import shuffle
import eegproject.settings as settings
import datetime

REPETITIONS = 10
MODALITIES = ['audio', 'text', 'image']

# Modalities x repetitions x seconds x concepts

def get_concepts():
    with open('eegbrowse/static/eegbrowse/text/Concepts.txt', 'r') as f:
        concepts =  f.readlines()
    concepts = [c.strip() for c in concepts]
    # print("These are the concepts: %s" % concepts)
    return concepts

def create_shuffled_stimuli(concepts):
    """
    This function creates a list of stimuli to show in a specific order. Each concept is proposed in each of its modalities for 20 times, so all in all we have 6 concepts times 3 modalities times 20 repetitions for a total of 360 iterations
    :param concepts:
    :return:
    """
    modality_concept_list = list()
    concepts_list = list()
    for modality in MODALITIES:
        tuple_el_list = list()
        for concept in concepts:
            tuple_el_list += [(modality, concept)] * REPETITIONS
        shuffle(tuple_el_list)
        modality_concept_list.append(tuple_el_list)
            #concepts_list = concepts_list + tuple_el_list
    audio_list = modality_concept_list[0]
    text_list = modality_concept_list[1]
    image_list = modality_concept_list[2]
    triple_list = zip(text_list, image_list, audio_list)
    
    #shuffle(concepts_list)
    # print("This is the concept list with elements %s" % concepts_list)
    datetoday = datetime.datetime.now().strftime("%B%d%Y") 
    with open('acquisition-'+datetoday+'.txt', 'w') as f:
        for triple in triple_list:
            for s in triple:
                # print(
                f.write('%s\n' % str(s))
                concepts_list.append(s)
    return concepts_list
