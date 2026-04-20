Return-Path: <live-patching+bounces-2403-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KOzPDB745WnjpgEAu9opvQ
	(envelope-from <live-patching+bounces-2403-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 11:55:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B404291CB
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 11:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2E7EC300F7BF
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 09:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEDEC389107;
	Mon, 20 Apr 2026 09:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gRx8VRMs"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB68346A1D;
	Mon, 20 Apr 2026 09:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776678934; cv=none; b=hQ9++kpVnOEqbxnl/SQifzEMTpInUnkBPV0d1ux2/ouiAfj0ErcF6kP1RQbW95v8dBkYMgfnL7A5u3Vl/subXvSjD6XhMlAQOhdkq8Mmd5jtK5z9OlbS7WV31UEJ41wepPU+O5piUsB6LJN93EsX4pDmb+Vh7yBBmZ7Ux4XylBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776678934; c=relaxed/simple;
	bh=5QKkiCJvo32D+OW+JM8PwJ8+u1c+y8+x+zDF+FPbXVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UvDivTSxVbIvRvREdFv7SEZP+D25eG3gT8Bdv8D0CvAAKrRUHLaXbrXVxPYfGEWTMetDwZ24Y8eAwqVhf8lH3VEgqlNWJkpMuJyiPrTXvpHFwn4wSjM2Ek2NzzefS7MFLPpYnw3H1gF3mG8Nw/UUNMTcdohZE0eQtKdg/0jKnmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gRx8VRMs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K9oRjD2042494;
	Mon, 20 Apr 2026 09:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AdXbxq
	kUmTO9CvSDuvNwcjAEn+Zqemb1tzrhtq/6zV0=; b=gRx8VRMsnjXNBUGKwlyy+G
	XlDEHHC7nF2ZI+CAeq0+TLYj2opFxlwTq2ozsemCGlH2ItWl8umRKJpphrpUqHh4
	HV7omtLJ8BfO0K1hNAabiGmT7oxZFZSKUgAbRS4ZxJrQzVGLMio6T1hbbMWCPfvW
	PXEybMwIzImm8PhUcRzZjXE36lVvJ2CGHkC5ggROwpjVdQBC2Wo1BuNpJpTFRd5M
	D9CjZDm3Wm152iPpG2n/xxJM9/NpTpvafTmqyySGz1A54I9Mdk9qLGUAoDUqI1Hm
	ocAhMALF9CbuPxLgDs7eObz1O5JzF9gWBoNtZxNufj8Txo1iMs8MtvEQeK0kR+4Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2j6f6ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:55:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63K9oI3U022781;
	Mon, 20 Apr 2026 09:55:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmn9jv7wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:55:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63K9swUN14025134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 09:54:58 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8F942004D;
	Mon, 20 Apr 2026 09:54:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC33B2004B;
	Mon, 20 Apr 2026 09:54:57 +0000 (GMT)
Received: from [9.111.165.155] (unknown [9.111.165.155])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Apr 2026 09:54:57 +0000 (GMT)
Message-ID: <d94bd394-5028-4ea9-9f7c-d860e3b2b50b@linux.ibm.com>
Date: Mon, 20 Apr 2026 11:54:57 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/8] arm64/module, sframe: Add sframe support for
 modules.
To: Dylan Hatch <dylanbhatch@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>, Indu Bhagat <ibhagatgnu@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Heiko Carstens <hca@linux.ibm.com>
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-7-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260406185000.1378082-7-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA5NSBTYWx0ZWRfX7sVYxR0BHm/i
 hljjXHeetDhUwhK3lWW6kS6kbsWB1/Yn8Ta4Iloibpb1F5i9NdDNRi9Rx3nj62TKzw/NY06S2gX
 tN5eM2MzJcCOk1xpa14nOqONkCqwe85n8NQkvpdHg+lNyUXwwaI3Qr8xSPbqXcOxEUpk6UjyYRL
 0yL1TS4Sd/NuwJOzlsjRvgzT8dbXN58tD+/l4HvdTmJm4A8vO2cgd1r+0Kn8y9LeGIc+AVsVhGw
 UQpPEEnsn5HM05P2m4hv+aitLTGo6qr2LmZq41X7hsUpKUUQxj5xjx+PeQagGqqTHjZwYbbYLcH
 N7x5ZQMbJNoQDoILFZyLHyb/82l4MKtuB3p19aV8ZOsszurkgLJEvsRPmgx2yZxoSDu1OjfxgX3
 ujtVH/Mt0dk6EypSEudC9f+TqUWRYgllg8scpujD/oTHAo0H9KSxq1frSigFXzNFOmqHm+NkhcG
 Ak1lPHSjYypBXIL7qdg==
X-Proofpoint-GUID: d8sMhmAkNsxBumVpl207QbRMzU3RT5F6
X-Authority-Analysis: v=2.4 cv=SOJykuvH c=1 sm=1 tr=0 ts=69e5f7f6 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=Z-62Obmmp1-fTq1nGjEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: sZxdhjZvSeDpti65nJZ9Tn8fe9HwOrAY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604200095
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2403-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[google.com,linux.dev,kernel.org,oracle.com,infradead.org,goodmis.org,arm.com,gmail.com];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 32B404291CB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/6/2026 8:49 PM, Dylan Hatch wrote:
> Add sframe table to mod_arch_specific and support sframe PC lookups when
> an .sframe section can be found on incoming modules.
> 
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Signed-off-by: Weinan Liu <wnliu@google.com>

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

> +void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
> +			void *text, size_t text_size)
> +{
> +	struct sframe_section sec;
> +

I think sec should better be explicitly zero-initialized, as it is done
in sframe_add_section() for user space.  IIUC likewise is not needed in
init_sframe_table() for the kernel vmlinux, as static variables are
zero-initialized.

	memset(&sec, 0, sizeof(sec));

> +	sec.sec_type	 = SFRAME_KERNEL;
> +	sec.sframe_start = (unsigned long)sframe;
> +	sec.sframe_end   = (unsigned long)sframe + sframe_size;
> +	sec.text_start   = (unsigned long)text;
> +	sec.text_end     = (unsigned long)text + text_size;
> +
> +	if (WARN_ON(sframe_read_header(&sec)))
> +		return;
> +
> +	mod->arch.sframe_sec = sec;
> +	mod->arch.sframe_init = true;
> +}
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


