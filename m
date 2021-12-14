Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8A24744DB
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 15:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhLNO0f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 09:26:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231143AbhLNO0f (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:35 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BED90JX007433;
        Tue, 14 Dec 2021 14:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=5IDVvaOqs/M3ujUhAS1nkCGOrtDe4vl4SwHL89S0Xdg=;
 b=cJjOtaJJPkquyFm0ftVR55TchRrTILl+LolXcdVOi0x4v3W9jGq8vSxNiJ57/yA8Abye
 oN0ms9Ck+SKBi60uyq0luSiRcsbdha+DqXaMSSYtfQ1/aLuNo7NwszIv4i63vqd6FNJ6
 evMdGA2zHrj98vyA4+Kn1b90aXfFtmY9VhZ82rUC1ePPgcYby6RPg7Dutu0qX3uT4uni
 UZvXk+SuJqFIpAi6MXMQtSr148al5vGvMReRW3Tz/rL3MR2CCeFEQ+Gj+T4rmMJboVxl
 xzFisyHXbfBisLTfEUikuwpg3hESpbFgMbDpRYGH/uKCNZQsWCQLPRHIg1yZ3EEVXS/+ FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9ptk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 14:26:05 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BEDCXJg015524;
        Tue, 14 Dec 2021 14:26:04 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9ptj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 14:26:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BEDiCfN032733;
        Tue, 14 Dec 2021 14:26:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3cvk8j035r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 14:26:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BEEPxsf43909628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 14:25:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB5CC4C04A;
        Tue, 14 Dec 2021 14:25:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 484894C04E;
        Tue, 14 Dec 2021 14:25:59 +0000 (GMT)
Received: from osiris (unknown [9.145.168.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 14 Dec 2021 14:25:59 +0000 (GMT)
Date:   Tue, 14 Dec 2021 15:25:57 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
Message-ID: <YbipdU5X4HNDWIni@osiris>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
 <20211028093547.48c69dfe@gandalf.local.home>
 <6209682d-0caa-b779-8763-376a984d8ed8@csgroup.eu>
 <20211213121536.25e5488d@gandalf.local.home>
 <5511f43c-192a-622b-7c72-52e07f0032c2@csgroup.eu>
 <20211213123338.65eda5a0@gandalf.local.home>
 <fc3099b8-9f12-3e47-08a0-05abc37a0482@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc3099b8-9f12-3e47-08a0-05abc37a0482@csgroup.eu>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JnbFfRm75kVyNUBP3Cs4lugyZBEgQEnO
X-Proofpoint-GUID: 3DaxL9v1MACAb8vQfjQA_AaDRKRC4gR5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_06,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 suspectscore=0 mlxlogscore=832 lowpriorityscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140082
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Dec 13, 2021 at 05:50:52PM +0000, Christophe Leroy wrote:
> Le 13/12/2021 à 18:33, Steven Rostedt a écrit :
> > On Mon, 13 Dec 2021 17:30:48 +0000
> > Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
> > 
> >> Thanks, I will try that.
> >>
> >> I can't find ftrace_graph_func() in s390. Does it mean that s390 doesn't
> >> have a working function tracer anymore ?
> >>
> >> I see your commit 0c0593b45c9b4 ("x86/ftrace: Make function graph use
> >> ftrace directly") is dated 8 Oct 2021 while 5740a7c71ab6 ("s390/ftrace:
> >> add HAVE_DYNAMIC_FTRACE_WITH_ARGS support") is 4 Oct 2021.
> > 
> > Hmm, maybe not. I can't test it.
> > 
> > This needs to be fixed if that's the case.
> > 
> > Thanks for bringing it up!

It still works, we run the full ftrace/kprobes selftests from the
kernel every day on multiple machines with several kernels (besides
other Linus' tree, but also linux-next). That said, I wanted to change
s390's code follow what x86 is currently doing anyway.

One thing to note: commit 5740a7c71ab6 ("s390/ftrace: add
HAVE_DYNAMIC_FTRACE_WITH_ARGS support") looks only that simple because
ftrace_caller _and_ ftrace_regs_caller used to save all register
contents into the pt_regs structure, which never was a requirement,
but implicitly fulfills the HAVE_DYNAMIC_FTRACE_WITH_ARGS
requirements.
Not sure if powerpc passes enough register contents via pt_regs for
HAVE_DYNAMIC_FTRACE_WITH_ARGS though. Might be something to check?
