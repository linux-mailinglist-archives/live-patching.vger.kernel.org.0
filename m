Return-Path: <live-patching+bounces-2370-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AP21ATv74GlloAAAu9opvQ
	(envelope-from <live-patching+bounces-2370-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 17:07:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 662174103D2
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 17:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B00D30EFB49
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 15:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB5130B50F;
	Thu, 16 Apr 2026 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kVkUrTOk"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CBF23D2A1;
	Thu, 16 Apr 2026 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351906; cv=none; b=M9HZLjniq8EGbzb+5L3Je1e9ZSQXR4UTNYGITLAi+eM7ztLUQHVDmIvZ0ti29xvHCW8gax8xIYwhrUSZFYDOUsTlmJ9d9MAeHQ13M14OcvrFu+1SnJkofETuvaTaiBJREqE+qlwv/Ymo3bu3NoIM7TcEi/+IbndlQRwbSB0hXDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351906; c=relaxed/simple;
	bh=4VuJ8gdBOFhuUhDcHQUNqlBfgwvEsd7307O84Com4UY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sof5pumbZqpWmxSKDYQA2nkuC/Z4hQOXoev1TnB7pxKEuahOw1FmR7+a2q233K6tDM4R3/QP+slPBzoMh9JcHRXehREnW2gBlcjvARB8GxdmHZCiB3OSJsb0cXV/WsKAKKaHKCGMnuNNq89AdE7PoxWOz7+Imr8/q+M3kOJkN94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kVkUrTOk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G3DU1S435815;
	Thu, 16 Apr 2026 15:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FDhIJN
	kzyRhbrOnlr3Ssr/UqRv/BNHAmvWAkHArYosY=; b=kVkUrTOkO/dZwHXZzglQOi
	PHh4drWnA/GUs8h+dDm/eN9xt/30v+3x7CksJaP26/I/yJg+cwi28FPzeAlBXBSR
	YsGHw9kIzJ1XVaBcaeloarE3He/iSx3RM7BGGRVuh85/mq3vZHn1NlQ65l2bJ3e6
	wSMvDxiQb8+tm6yPcqVaajDs+Iuxufzc4w7+lPCNaN8KtxQyHwqNW72TyKmRXLLv
	8Xd7OYV/8ZRgB/QhNZX/8krEeqL/EKDW5K58Y8ue63Dv6awLeYN+i3iFvG2E17xG
	5h8/Wuh2aS96fiPew22eBr7tOfTGGqL3Uwpe+4UysCQAaEFHd7BtqXjRkZg8MRag
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89kd6a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 15:04:26 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63GC1GTB031106;
	Thu, 16 Apr 2026 15:04:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg10ykg9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 15:04:25 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63GF4NSm44040534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 15:04:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 476FC20040;
	Thu, 16 Apr 2026 15:04:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6134F20043;
	Thu, 16 Apr 2026 15:04:22 +0000 (GMT)
Received: from [9.111.199.83] (unknown [9.111.199.83])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 15:04:22 +0000 (GMT)
Message-ID: <de7bd273-3650-4378-8fd8-a51217e7284b@linux.ibm.com>
Date: Thu, 16 Apr 2026 17:04:19 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION.
To: Dylan Hatch <dylanbhatch@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Heiko Carstens <hca@linux.ibm.com>
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-8-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260406185000.1378082-8-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: LGktqNeCrtWBnCML3C6tEOuD6Fh7VnlS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEzNyBTYWx0ZWRfX9pop2o8ktxKt
 eAyZAyaLAxXH9ZP4qmHTQphFxeEJPFMuZBGOwD/6YL/wPQJcgyUqJwLQ0foDsTDQztWTvV0EdPL
 CrCDrbXD2/LiEgZBq2Jxwdz9W7qxabuvwggJ1sZ7nElk+xyB5ACB1kr2bt+CzFbXol8gPiqUty7
 Qn0EtA9MKS7Z4NoRuirwArpE8lqjtCmKul2X2wUKKjvqNOJkfpgDwg/6c06dWVjHxJ1UqQZg9Cf
 kJ7poFDH4XSBeHJ+PGIufM0j5My6gp2YE9d4uYnT/gdsDjhw6BGLukChKhEepJPlPPeKYfInI1Y
 uQJJ4E00EnRUFgsRvdWns1IBcyh9f7Tust2ynoBVGfB4e6L2SpuLJQbgoco32ZZGmk+6cnMbUs8
 24MIDSJZiyJCaj+J6kA+Gs9NdoDqGCGbuXmnm+4Vmu9nxKPVl5w7k8BZYAGMHSd9l8dmM4uNuLv
 YtysFuGgggr5WnjQFrQ==
X-Proofpoint-ORIG-GUID: 9nHZvSvL_Zh6PcFV8qu2Tjq2WgUvuWAe
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69e0fa7a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=Q2lZ1eOwVUoNMOp4RhMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160137
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2370-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 662174103D2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Dylan!

On 4/6/2026 8:49 PM, Dylan Hatch wrote:
> Generalize the __safe* helpers to support a non-user-access code path.
> Allow for kernel FDE read failures due to the presence of .rodata.text.
> This section contains code that can't be executed by the kernel
> direclty, and thus lies ouside the normal kernel-text bounds.

Nits: s/direclty/directly/ s/ouside/outside/

Could you please explain the issue?  How/why does .sframe for
.rodata.text pose an issue for .sframe verification?

> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

> @@ -690,6 +699,13 @@ static int sframe_validate_section(struct sframe_section *sec)
>  		int ret;
>  
>  		ret = safe_read_fde(sec, i, &fde);
> +		/*
> +		 * Code in .rodata.text is not considered part of normal kernel
> +		 * text, but there is no easy way to prevent sframe data from
> +		 * being generated for it.
> +		 */
> +		if (ret && sec->sec_type == SFRAME_KERNEL)
> +			continue;
>  		if (ret)
>  			return ret;
>  
Thanks and regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


