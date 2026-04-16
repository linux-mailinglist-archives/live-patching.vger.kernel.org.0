Return-Path: <live-patching+bounces-2369-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGyIMAz54GkloAAAu9opvQ
	(envelope-from <live-patching+bounces-2369-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 16:58:20 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2C3410053
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 16:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E1C93025481
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 14:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688823A6EF6;
	Thu, 16 Apr 2026 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OEwhZ5K5"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1172934DB4F;
	Thu, 16 Apr 2026 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351498; cv=none; b=P/Yoypv7bsB+kRBPN2wAgLllZgok4K5LMGh2xJuB0MxbU6+mFknamuGZ5o0ylxGcC0FdpB5FyAgSFfQshNeNt3u+BlluVssPiJ8Q2L48LagavfLV5sr4OiA8DGrE5udyG6CXiXba9EycTG6S7T2y1/aK4fh0pPI1ra0NdJdBSaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351498; c=relaxed/simple;
	bh=rwoWBAI19GGSXGBzeZCHMwA0DT8fetfYb6JRWXv7sC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQwUL9jFJ6QJE1qzxzfmFUfdBmCTum2wbJbGKKPdk1OxKxT02ebl2cMdOGoX/TPqP8TN1TRx3A0+sU/6lY8Q8dJTaEYnGaN/J39uEzcMtF0po5fThgkHFZNzuRCBqF9eHqAYhxMNwHNfx30X4kH5pZRGyZgguKt9+KSMGEC5GMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OEwhZ5K5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FNsdiF123217;
	Thu, 16 Apr 2026 14:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IiFTqN
	RsW+CS1xyti7DFe/0/7O0KPEJESBzPaT2EaKY=; b=OEwhZ5K5GzpnqOsL6J8tzX
	orFny0soLKWrR5LMVi98dWuUKoeVo3nn8171NgQ+qgYRyLyg4cGQxwgKtnJ21+Be
	cqjlyIMt2Ig6vIRSwDJijFtP4G1rGQsR3yWocHYn1f5FZlqqq5JoOc/ey3FDzSOK
	mesMB73/4dE3k7mWs59ei41cfj5EcpDqJGLAnjjRE7fm0FUPeAtHhRshqkXauMJ5
	W6GGVg7t5GXWBSQbCRrQbK+PolaU1gDmv/6bt9vm1mXBFbm1LKWYC2Cstd2jb4Rz
	olFlWGIUs2U7XLCrC+Niz357DACz608+ogPr8MWII8xnxBn/DWKM8NagLXvjqaiQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89pn4wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 14:57:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63GBGvSx015206;
	Thu, 16 Apr 2026 14:57:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0msuhkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 14:57:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63GEviiY44040564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 14:57:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 044E920043;
	Thu, 16 Apr 2026 14:57:44 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 207B820040;
	Thu, 16 Apr 2026 14:57:43 +0000 (GMT)
Received: from [9.111.199.83] (unknown [9.111.199.83])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 14:57:43 +0000 (GMT)
Message-ID: <52b8f4c6-baa6-4163-8dbd-4b0789389455@linux.ibm.com>
Date: Thu, 16 Apr 2026 16:57:40 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/8] sframe: Allow unsorted FDEs.
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
 <20260406185000.1378082-6-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260406185000.1378082-6-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: ZM9UdjMfRQTtwPFkdWXaQp2GrTAo940S
X-Proofpoint-ORIG-GUID: YfFfJ_XYa4519ZbQXfQQ9UzoQjC4ENhB
X-Authority-Analysis: v=2.4 cv=WbE8rUhX c=1 sm=1 tr=0 ts=69e0f8eb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=LFt20mCCc4CE-LtB3JUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEzNyBTYWx0ZWRfXwHEumePO8J3y
 +bEHaemOIo9ZzaNBvXdmjlh1I7YlodIIZ/JXgqyJc1jYGRLACpwnznCPgaqx6IbKbWPzSe9zAsV
 SvviQYO6I0WO6pVbojGXktjEE73Msfz1+H1rgdZ5IOdIlNoYZHf401kgFrHgicutvvZMb+x5B+M
 0eB+R4DrbgPsPCj1LyafgubYeEEQyS7qZ58MUXIikdb30EYr0J3wV9wx0B/uH6Obmn5Zr6yUL6D
 bLaKn3TNiL14x9A+wRDEpZAjggto9tc8d9gGfLAydBht0PK2OuQLkOOTFHnqY4a9cKi99kDK2M2
 xR/Qo577BcxhQnc8yVNtEoXjJW+ZZwZNIh8yIVq7dcllxF1dfFpXVwXEqtOHzVPNrIVJmCV9csm
 19NMbEjojO+hDNAiN3A4sqxx4yFnDkM3+RTjcr+1DksCFjMrVpAXUInYKz/PgsFIpPUnC31OxKG
 dMzZXrrbVuhhjq7Flow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160137
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2369-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 3C2C3410053
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/6/2026 8:49 PM, Dylan Hatch wrote:
> The .sframe in kernel modules is built without SFRAME_F_FDE_SORTED set.
> In order to allow sframe PC lookup in modules, add a code path to handle
> unsorted FDE tables by doing a simple linear search.
> 
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

With my below two minor comments considered:

Reviewed-by: Jens Remus <jremus@linux.ibm.com>

> diff --git a/include/linux/sframe.h b/include/linux/sframe.h

> @@ -64,6 +64,7 @@ struct sframe_section {
>  	unsigned long		text_start;
>  	unsigned long		text_end;
>  
> +	bool			fdes_sorted;
>  	unsigned long		fdes_start;
>  	unsigned long		fres_start;
>  	unsigned long		fres_end;

The struct would be smaller if the bool fdes_sorted flag would be
inserted after the unsigned int num_fdes field:

$ pahole -C sframe_section kernel/unwind/sframe.o

Yours:
size: 96

With bool fdes_sorted moved after unsigned int num_fdes:
size: 88

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

> @@ -179,9 +179,34 @@ static __always_inline int __read_fde(struct sframe_section *sec,
>  	return -EFAULT;
>  }
>  
> -static __always_inline int __find_fde(struct sframe_section *sec,
> -				      unsigned long ip,
> -				      struct sframe_fde_internal *fde)
> +static __always_inline int __find_fde_unsorted(struct sframe_section *sec,
> +					       unsigned long ip,
> +					       struct sframe_fde_internal *fde)
> +{
> +	struct sframe_fde_v3 *cur, *start, *end;
> +
> +	start = (struct sframe_fde_v3 *)sec->fdes_start;
> +	end = start + sec->num_fdes;
> +
> +	for (cur = start; cur < end; cur++) {
> +		s64 func_off;
> +		u32 func_size;
> +		unsigned long func_addr;
> +
> +		DATA_GET(sec, func_off, &cur->func_start_off, s64, Efault);
> +		DATA_GET(sec, func_size, &cur->func_size, u32, Efault);
> +		func_addr = (unsigned long)cur + func_off;
> +
> +		if (ip >= func_addr && ip < func_addr + func_size)
> +			return __read_fde(sec, cur - start, fde);
> +	}

__find_fde() (now __find_fde_sorted()) returns -EINVAL, if no FDE is found:

	return -EINVAL;

> +Efault:
> +	return -EFAULT;
> +}
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


