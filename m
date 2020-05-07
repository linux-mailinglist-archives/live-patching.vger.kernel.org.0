Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DE11C8AB6
	for <lists+live-patching@lfdr.de>; Thu,  7 May 2020 14:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgEGM2A (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 May 2020 08:28:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725923AbgEGM17 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 May 2020 08:27:59 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 047C422X113559;
        Thu, 7 May 2020 08:27:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4vabmgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 08:27:50 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 047C6Vwx121760;
        Thu, 7 May 2020 08:27:50 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4vabmfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 08:27:50 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 047CKEA1028886;
        Thu, 7 May 2020 12:27:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g5cmh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 12:27:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 047CRk9f56295540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 May 2020 12:27:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18626AE056;
        Thu,  7 May 2020 12:27:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3003AE051;
        Thu,  7 May 2020 12:27:45 +0000 (GMT)
Received: from thinkpad (unknown [9.145.63.153])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 May 2020 12:27:45 +0000 (GMT)
Date:   Thu, 7 May 2020 14:27:44 +0200
From:   Gerald Schaefer <gerald.schaefer@de.ibm.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v4 06/11] s390/module: Use s390_kernel_write() for late
 relocations
Message-ID: <20200507142744.05271ac0@thinkpad>
In-Reply-To: <nycvar.YFH.7.76.2005071159490.25812@cbobk.fhfr.pm>
References: <cover.1588173720.git.jpoimboe@redhat.com>
        <4710f82c960ff5f8b0dd7dba6aafde5bea275cfa.1588173720.git.jpoimboe@redhat.com>
        <nycvar.YFH.7.76.2005071159490.25812@cbobk.fhfr.pm>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_06:2020-05-07,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070094
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 7 May 2020 12:00:13 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> wrote:

> On Wed, 29 Apr 2020, Josh Poimboeuf wrote:
> 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > Because of late module patching, a livepatch module needs to be able to
> > apply some of its relocations well after it has been loaded.  Instead of
> > playing games with module_{dis,en}able_ro(), use existing text poking
> > mechanisms to apply relocations after module loading.
> > 
> > So far only x86, s390 and Power have HAVE_LIVEPATCH but only the first
> > two also have STRICT_MODULE_RWX.
> > 
> > This will allow removal of the last module_disable_ro() usage in
> > livepatch.  The ultimate goal is to completely disallow making
> > executable mappings writable.
> > 
> > [ jpoimboe: Split up patches.  Use mod state to determine whether
> > 	    memcpy() can be used.  Test and add fixes. ]
> > 
> > Cc: linux-s390@vger.kernel.org
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> > Acked-by: Miroslav Benes <mbenes@suse.cz>
> 
> Could we please get an Ack / Reviewed-by: for this patch from s390 folks?
> 
> Thanks,
> 

Looks pretty straightforward, and using s390_kernel_write() is OK, so

Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com> # s390
