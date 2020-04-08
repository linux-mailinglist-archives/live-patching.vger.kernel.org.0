Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDFE91A1EB4
	for <lists+live-patching@lfdr.de>; Wed,  8 Apr 2020 12:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDHKXN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 8 Apr 2020 06:23:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbgDHKXM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 8 Apr 2020 06:23:12 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038A34C4061044
        for <live-patching@vger.kernel.org>; Wed, 8 Apr 2020 06:23:11 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3092057qcr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Wed, 08 Apr 2020 06:23:11 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Wed, 8 Apr 2020 11:22:43 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 11:22:39 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 038AN3cC41025560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 10:23:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 490874204F;
        Wed,  8 Apr 2020 10:23:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F056C42049;
        Wed,  8 Apr 2020 10:23:00 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.199.62.55])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  8 Apr 2020 10:23:00 +0000 (GMT)
Subject: Re: Live patching MC at LPC2020?
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Nicolai Stange <nstange@suse.com>,
        Jason Baron <jbaron@akamai.com>,
        Gabriel Gomes <gagomes@suse.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>,
        Michael Matz <matz@suse.de>, ulp-devel@opensuse.org,
        live-patching@vger.kernel.org
References: <nycvar.YFH.7.76.2003271409380.19500@cbobk.fhfr.pm>
 <20200331205204.GA7388@redhat.com>
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date:   Wed, 8 Apr 2020 15:52:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331205204.GA7388@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040810-0016-0000-0000-00000300A508
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040810-0017-0000-0000-00003364840F
Message-Id: <57a1a529-3afb-988e-f5a8-f979d8a1fe12@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080084
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 4/1/20 2:22 AM, Joe Lawrence wrote:
> On Fri, Mar 27, 2020 at 02:20:52PM +0100, Jiri Kosina wrote:
>> Hi everybody,
>>
>> oh well, it sounds a bit awkward to be talking about any conference plans 
>> for this year given how the corona things are untangling in the world, but 
>> LPC planning committee has issued (a) statement about Covid-19 (b) call 
>> for papers (as originally planned) nevertheless. Please see:
>>
>> 	https://linuxplumbersconf.org/
>> 	https://linuxplumbersconf.org/event/7/abstracts/
>>
>> for details.
>>
>> Under the asumption that this Covid nuisance is over by that time and 
>> travel is possible (and safe) again -- do we want to eventually submit a 
>> livepatching miniconf proposal again?
>>
>> I believe there are still kernel related topics on our plate (like revised 
>> handling of the modules that has been agreed on in Lisbon and Petr has 
>> started to work on, the C parsing effort by Nicolai, etc), and at the same 
>> time I'd really like to include the new kids on the block too -- the 
>> userspace livepatching folks (CCing those I know for sure are working on 
>> it).
>>
> 
> Hi Jiri,
> 
> First off, I hope everyone is riding out COVID-19 as well as possible,
> considering all that's happening.
> 
> As for LPC mini-conf topics, I'd be interested in (at least):
> 
> - Petr's per-object livepatch POC
> - klp-convert status
> - objtool hacking
> - Nicolai's klp-ccp status
> - arch update (arm64, etc)

Hi Jiri,

I hope everyone is keeping safe. I would be interested in the topics listed
by Joe and in userspace patching. 

> 
>> So, please if you have any opinion one way or the other, please speak up. 
>> Depending on the feedback, I will be fine handling the logistics of the 
>> miniconf submission as last year (together with Josh I guess?) unless 
>> someone else wants to step up and volunter himself :)
>>
>> (*) which is totally unclear, yes -- for example goverment in my country 
>>     has been talking for border closure lasting for 1+ years ... but it 
>>     all depends on how things develop of course).
> 
> Hmm, all good points.  Some conferences have gone virtual to cope with
> necessary cancellations, but who knows what things will look like even
> at the end of August.  Perhaps we can still do something remotely if the
> conditions dictate it.  But my vote would be yes, and let's see what
> topics interest folks.
> 

Regards,
Kamalesh

