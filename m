Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D1B4B54B9
	for <lists+live-patching@lfdr.de>; Mon, 14 Feb 2022 16:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343529AbiBNP0Y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Feb 2022 10:26:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240044AbiBNP0Y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Feb 2022 10:26:24 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEC660A94;
        Mon, 14 Feb 2022 07:26:16 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EFOPpi012649;
        Mon, 14 Feb 2022 15:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=CTbUY2hl0sfw79lUnt28hPNQO1kDDJya8WniS70Dynk=;
 b=N8x+p0bvLO1Zl7MdcxW+DIV9bJvL4pURIaEQcjS8moT9zhkS/KlJfnMg2c8aruvNVq4w
 oe5dXUkkJUFgQO48sf5u+Frm3BcpqiTIxVO4D6YbE3n8qPkunLYswv+mSscBQmqq7Spb
 cIqtdOVrhJIQ8XKuLCKk8DzFhZ0WBgGjrRDLZ8+sADMK2YJBEo0MglvbYyv0QrN1Don5
 2nYC3c98cPszCYtfu71Rg/AESU4s6hxxAmAWrg9OQOUF2cG+MQ+jioJ7dcEPCA8qNgZq
 kfnzs5H6bFTS3yT24UhmUmz+q6kv0XGaV4+BjrVHqF6JUSTRr4SITmuLVmBgO1+S9DWM 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7920vk9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 15:25:42 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EFOxa0014955;
        Mon, 14 Feb 2022 15:25:41 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7920vk8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 15:25:41 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EFBrql025996;
        Mon, 14 Feb 2022 15:25:39 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3e64h9dvh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 15:25:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EFPaFr45744402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 15:25:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C3C14C046;
        Mon, 14 Feb 2022 15:25:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9A9F4C052;
        Mon, 14 Feb 2022 15:25:35 +0000 (GMT)
Received: from localhost (unknown [9.43.124.167])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 15:25:35 +0000 (GMT)
Date:   Mon, 14 Feb 2022 20:55:33 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 09/13] powerpc/ftrace: Implement
 CONFIG_DYNAMIC_FTRACE_WITH_ARGS
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
References: <cover.1640017960.git.christophe.leroy@csgroup.eu>
        <5831f711a778fcd6eb51eb5898f1faae4378b35b.1640017960.git.christophe.leroy@csgroup.eu>
In-Reply-To: <5831f711a778fcd6eb51eb5898f1faae4378b35b.1640017960.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
User-Agent: astroid/4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1644852011.qg7ud9elo2.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U_R1WC4bISAb4FaYFWLfhme_IU7ZkUnM
X-Proofpoint-ORIG-GUID: LZ_RkunqBHntcveHRdbfJBKGSEYZeo5L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_06,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Christophe Leroy wrote:
> Implement CONFIG_DYNAMIC_FTRACE_WITH_ARGS. It accelerates the call
> of livepatching.
>=20
> Also note that powerpc being the last one to convert to
> CONFIG_DYNAMIC_FTRACE_WITH_ARGS, it will now be possible to remove
> klp_arch_set_pc() on all architectures.
>=20
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
>  arch/powerpc/Kconfig                 |  1 +
>  arch/powerpc/include/asm/ftrace.h    | 17 +++++++++++++++++
>  arch/powerpc/include/asm/livepatch.h |  4 +---
>  3 files changed, 19 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index cdac2115eb00..e2b1792b2aae 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -210,6 +210,7 @@ config PPC
>  	select HAVE_DEBUG_KMEMLEAK
>  	select HAVE_DEBUG_STACKOVERFLOW
>  	select HAVE_DYNAMIC_FTRACE
> +	select HAVE_DYNAMIC_FTRACE_WITH_ARGS	if MPROFILE_KERNEL || PPC32
>  	select HAVE_DYNAMIC_FTRACE_WITH_REGS	if MPROFILE_KERNEL || PPC32
>  	select HAVE_EBPF_JIT
>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS	if !(CPU_LITTLE_ENDIAN && POWER7=
_CPU)
> diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm=
/ftrace.h
> index b3f6184f77ea..45c3d6f11daa 100644
> --- a/arch/powerpc/include/asm/ftrace.h
> +++ b/arch/powerpc/include/asm/ftrace.h
> @@ -22,6 +22,23 @@ static inline unsigned long ftrace_call_adjust(unsigne=
d long addr)
>  struct dyn_arch_ftrace {
>  	struct module *mod;
>  };
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_ARGS
> +struct ftrace_regs {
> +	struct pt_regs regs;
> +};
> +
> +static __always_inline struct pt_regs *arch_ftrace_get_regs(struct ftrac=
e_regs *fregs)
> +{
> +	return &fregs->regs;
> +}

I think this is wrong. We need to differentiate between ftrace_caller()=20
and ftrace_regs_caller() here, and only return pt_regs if coming in=20
through ftrace_regs_caller() (i.e., FL_SAVE_REGS is set).

> +
> +static __always_inline void ftrace_instruction_pointer_set(struct ftrace=
_regs *fregs,
> +							   unsigned long ip)
> +{
> +	regs_set_return_ip(&fregs->regs, ip);

Should we use that helper here? regs_set_return_ip() also updates some=20
other state related to taking interrupts and I don't think it makes=20
sense for use with ftrace.


- Naveen

