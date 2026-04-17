Return-Path: <live-patching+bounces-2381-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wNGwF9I+4mmB3wAAu9opvQ
	(envelope-from <live-patching+bounces-2381-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 16:08:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB86041BDF7
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 16:08:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F98030682EB
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 14:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB5D359703;
	Fri, 17 Apr 2026 14:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="alGSQWaJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4334627E1DC;
	Fri, 17 Apr 2026 14:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776434891; cv=none; b=Btlxorrb+bi1Ia6vPsjvwD9b+9swg3r1dIViywkTNPvK2Q8mx/Mv36WkM/2xUODYfbXM+H6hNJa9L7gOOhC17KchaRm1h9yJqVbTispduhTHtgK5H7F3q+V5brbgVW6W1czI2w1WRtwWbbjGYfbFGUCKFGZYGcNRyLAB68vBLws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776434891; c=relaxed/simple;
	bh=Hn6Tl+MIuPs4EOgWs8zJGEBrRSgbu/Kwnrx1ugM1hnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M0sn2DIvUN6NZ7ZnCFtLgpy4MWhMrJ4OXog+jUw/A8U/xp9Q8zkasGung3vR1F0SjkSPTN1SgR2pUpvux/JrvPZpS949bpYGzK4vV5Ju/KG82koEmCiOj76GczI3DcbEyVqlR1f4epvj/oM2IOW57mXOaKY1Y0Vfn+vTNT3PFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=alGSQWaJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63GNTMiG1733620;
	Fri, 17 Apr 2026 14:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TlNuUk
	MMEWzUg5xgSeUvQAPo/uuSpi+KlN/YiH0P+dU=; b=alGSQWaJeN8chMi4PAqZat
	nN7h7iKO3g/K4j10eDx0mRVbsDvwFkVosmSDgV+v8kFgvCru1YXmuOyZyyukKVj9
	Rngl+oJIzujpKhzj5aE7CBr4H6Qpog+PWqQjtKkIYv5UISKxe7QGbZZTUrRYInZj
	2684JLtW/3yYqV8hMxQ95+ndYvnlqL4ssbvxvCsz+/oSvEL2MymC/Px/M+eTw6Va
	pRkFmnZQiPKdQYhFxiwBArStAv0c+9uNhRAxOo4Ch1Sr5Jns10AAchM9zVYiSNRB
	VBPaLt2vp2uWnMjpSRx5aMEBiaqDTzLwTHQ8+8qZIV4tIunD9PiCGVagpAQcTeeg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mhngs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Apr 2026 14:07:43 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63HDSsiZ004180;
	Fri, 17 Apr 2026 14:07:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg24kqdrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Apr 2026 14:07:42 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63HE7e1c48824612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 14:07:41 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E31CD20049;
	Fri, 17 Apr 2026 14:07:40 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1D1720040;
	Fri, 17 Apr 2026 14:07:39 +0000 (GMT)
Received: from [9.111.133.81] (unknown [9.111.133.81])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Apr 2026 14:07:39 +0000 (GMT)
Message-ID: <8038ee8e-7ae1-4e78-bc9e-b4be3c45b9fe@linux.ibm.com>
Date: Fri, 17 Apr 2026 16:07:37 +0200
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
        Jiri Kosina <jikos@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
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
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69e23eb0 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=Zg_fgM-7fzLk7_7bOdYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GbpJRiYixfWQ4y6ZTEhjhUUyzJYrr6MQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDEzOSBTYWx0ZWRfX1yf790PESF22
 Rk4dB9PWxBX1aYnZNMA6AbEQ06fzvYXrD+K5Tb/Jy5LDj6Sr3qkqzFm6iIqe0oowI5Qf+pIIaeB
 rqb6M5b79YL61Mv8paZZ0Mu9qFpTla0aujYW1xHxHjTfbBda8bvzXKRD9rVg5Hcz71P+a7LixUN
 jZZAEqilRtxirTWzRKk0Nk5RQp4ahFbYBxVcRS61q6kpdtmxHfV8rza03SQ0wz/qW7bWkxwEckk
 PvQeLsFLrKOhZvHREgVaadDZT7EVwSSSedc0zpheH1YQJtANAfNNPXjbwi4HBiwl21pLI6VUo9I
 aWsJ+sKoeCcARJlJDH+yJypjssqXptoDKx/SsQnLD1juQU058jBICxAp2IcwZPLFKtFVV2ubcoJ
 tLc7ZCTqMOUemxnyOtjenHqQSVWRY+d6xsh1gKd7EMHbPJ7UvGMFE1BYpaXvK9TWs9uEE/n92lS
 DP2gqh8aLM3Cj1yYOhQ==
X-Proofpoint-ORIG-GUID: lPa8A0_fWUVbig-FNGkSf7Bd5o1dLrF_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170139
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2381-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: EB86041BDF7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/6/2026 8:49 PM, Dylan Hatch wrote:
> Add sframe table to mod_arch_specific and support sframe PC lookups when
> an .sframe section can be found on incoming modules.
> 
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Signed-off-by: Weinan Liu <wnliu@google.com>

Reviewed-by: Jens Remus <jremus@linux.ibm.com>

> ---
>  arch/arm64/include/asm/module.h |  6 +++++
>  arch/arm64/kernel/module.c      |  8 +++++++
>  include/linux/sframe.h          |  2 ++
>  kernel/unwind/sframe.c          | 39 +++++++++++++++++++++++++++++++--
>  4 files changed, 53 insertions(+), 2 deletions(-)
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


