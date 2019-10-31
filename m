Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23715EB3D9
	for <lists+live-patching@lfdr.de>; Thu, 31 Oct 2019 16:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfJaPZA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 31 Oct 2019 11:25:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27654 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727707AbfJaPZA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 31 Oct 2019 11:25:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9VFGTux064475
        for <live-patching@vger.kernel.org>; Thu, 31 Oct 2019 11:24:59 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w013836tq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Thu, 31 Oct 2019 11:24:59 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Thu, 31 Oct 2019 15:24:57 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 15:24:53 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9VFOpWo61145192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 15:24:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D3FB4C044;
        Thu, 31 Oct 2019 15:24:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0D874C04A;
        Thu, 31 Oct 2019 15:24:50 +0000 (GMT)
Received: from osiris (unknown [9.152.212.85])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 31 Oct 2019 15:24:50 +0000 (GMT)
Date:   Thu, 31 Oct 2019 16:24:49 +0100
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     gor@linux.ibm.com, borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, pmladek@suse.com,
        nstange@suse.de, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/3] s390/livepatch: Implement reliable stack tracing
 for the consistency model
References: <20191029143904.24051-1-mbenes@suse.cz>
 <20191029163450.GI5646@osiris>
 <alpine.LSU.2.21.1910301105550.18400@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1910301105550.18400@pobox.suse.cz>
X-TM-AS-GCONF: 00
x-cbid: 19103115-4275-0000-0000-0000037996D8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103115-4276-0000-0000-0000388CD60A
Message-Id: <20191031152449.GA6133@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=493 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310155
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 30, 2019 at 11:12:00AM +0100, Miroslav Benes wrote:
> On Tue, 29 Oct 2019, Heiko Carstens wrote:
> 
> > On Tue, Oct 29, 2019 at 03:39:01PM +0100, Miroslav Benes wrote:
> > > - I tried to use the existing infrastructure as much as possible with
> > >   one exception. I kept unwind_next_frame_reliable() next to the
> > >   ordinary unwind_next_frame(). I did not come up with a nice solution
> > >   how to integrate it. The reliable unwinding is executed on a task
> > >   stack only, which leads to a nice simplification. My integration
> > >   attempts only obfuscated the existing unwind_next_frame() which is
> > >   already not easy to read. Ideas are definitely welcome.
> > 
> > Ah, now I see. So patch 2 seems to be leftover(?). Could you just send
> > how the result would look like?
> > 
> > I'd really like to have only one function, since some of the sanity
> > checks you added also make sense for what we already have - so code
> > would diverge from the beginning.
> 
> Ok, that is understandable. I tried a bit harder and the outcome does not 
> look as bad as my previous attempts (read, I gave up too early).
> 
> I deliberately split unwind_reliable/!unwind_reliable case in "No 
> back-chain, look for a pt_regs structure" branch, because the purpose is 
> different there. In !unwind_reliable case we can continue on a different 
> stack (if I understood the code correctly when I analyzed it in the past. 
> I haven't found a good documentation unfortunately :(). While in 
> unwind_realiable case we just check if there are pt_regs in the right 
> place on a task stack and stop. If there are not, error out.
> 
> It applies on top of the patch set. Only compile tested though. If it 
> looks ok-ish to you, I'll work on it.

Yes, that looks much better. Note, from a coding style perspective the
80 characters per line limit is _not_ enforced on s390 kernel code; so
that might be a possibility to make the code a bit more readable.

Also it _might_ make sense to split the function into two or more
functions (without duplicating code). Not sure if that would really
increase readability though.

FWIW, I just applied your first patch, since it makes sense anyway.

