Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5550D4B89D2
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 14:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiBPN2A (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 08:28:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbiBPN2A (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 08:28:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8DA9AD9C;
        Wed, 16 Feb 2022 05:27:47 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GDBVuh017654;
        Wed, 16 Feb 2022 13:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=mRSsAAv1qAwMSzykjnfczfeoZXgX0Jf2TbNRCxVF9Uc=;
 b=sriKSFpp5nLsg21MUdSk+raY/gt5P/cYyz3oLXy3aQ97RtZYY21Y46ojqfudPLd67Hdl
 T6TPWcouUMtyDP+h7l/S9mlTqAe2WmTG3zdVwfoWsrxv8X4VSwljdU+nFv+ZUZsinKVA
 RPmji7gyCs2vrurwp0EGN9uP3lKF9c514SlVAbWyXxKo+wrF9W+CX0R2QfgUuvytibv5
 xibdOs+goM4K5JoYD7j/Eq3pnATrCc0akUCczZ3xyEnCPU9pKIQ1EZ0uVgR6zhKLQcoQ
 usOdkgBh2MiH66BkZv1EoKO+j03DgBm49BPHVdxGfQhB+zhWIrFHbaCH+59BAhIS6bVH CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e908qjh1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 13:27:16 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GDDqFG027694;
        Wed, 16 Feb 2022 13:27:15 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e908qjh17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 13:27:15 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GDC9Du006745;
        Wed, 16 Feb 2022 13:27:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3e64h9q865-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 13:27:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GDRAb924903942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 13:27:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16A3A11C054;
        Wed, 16 Feb 2022 13:27:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9467B11C05B;
        Wed, 16 Feb 2022 13:27:09 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 16 Feb 2022 13:27:09 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2 09/13] powerpc/ftrace: Implement
 CONFIG_DYNAMIC_FTRACE_WITH_ARGS
References: <cover.1640017960.git.christophe.leroy@csgroup.eu>
        <5831f711a778fcd6eb51eb5898f1faae4378b35b.1640017960.git.christophe.leroy@csgroup.eu>
        <1644852011.qg7ud9elo2.naveen@linux.ibm.com>
        <1b28f52a-f8b7-6b5c-e726-feac4123517d@csgroup.eu>
        <875ypgo0f3.fsf@mpe.ellerman.id.au>
        <1644930705.g64na2kgvd.naveen@linux.ibm.com>
        <6dc50f09-4d14-afa2-d2a1-34b72b880edf@csgroup.eu>
        <5c7b5334-6071-f131-a509-9a49ca3d628c@csgroup.eu>
        <1644941712.lqdstzo09z.naveen@linux.ibm.com> <Ygz2Upu+5NiEAsDT@osiris>
Date:   Wed, 16 Feb 2022 14:27:09 +0100
In-Reply-To: <Ygz2Upu+5NiEAsDT@osiris> (Heiko Carstens's message of "Wed, 16
        Feb 2022 14:04:18 +0100")
Message-ID: <yt9dmtir3psi.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4P13vTTY8jUoKkrC9N3P8RbRIK8AStlA
X-Proofpoint-ORIG-GUID: Rv68b89V4IpwCICup99AtZAzo4shCls4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_06,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 mlxlogscore=764 priorityscore=1501 malwarescore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Heiko Carstens <hca@linux.ibm.com> writes:

> So, the in both variants s390 provides nearly identical data. The only
> difference is that for FL_SAVE_REGS the program status word mask is
> missing; therefore it is not possible to figure out the condition code
> or if interrupts were enabled/disabled.
>
> Vasily, Sven, I think we have two options here:
>
> - don't provide sane psw mask contents at all and say (again) that
>   ptregs contents are identical
>
> - provide (finally) a full psw mask contents using epsw, and indicate
>   validity with a flags bit in pt_regs
>
> I would vote for the second option, even though epsw is slow. But this
> is about the third or fourth time this came up in different
> contexts. So I'd guess we should go for the slow but complete
> solution. Opinions?

Given that this only affects ftrace_regs_caller, i would also vote for the
second option.
