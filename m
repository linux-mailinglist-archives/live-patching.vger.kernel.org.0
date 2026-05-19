Return-Path: <live-patching+bounces-2865-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMdfBfFNDGpIeQUAu9opvQ
	(envelope-from <live-patching+bounces-2865-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 13:48:01 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2F557DF76
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 13:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0EA2531DB3DA
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 11:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A674963B8;
	Tue, 19 May 2026 11:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AQIKKu5X"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F7E397E81;
	Tue, 19 May 2026 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779189631; cv=none; b=Ub83u+Bn1/rZiaFmp8yG5t7wh9iNy+0ufxADXcaElbzuMYzf3WLPPROH9kaKFRbXVXvxMZw/Vsm9rA6x7QqLZQme5fBzxFE41ce6e37iefXO91iCUM3NMsmScJjRgAeoHEqO6MxxcShovjj1nOZzEndQdAVMN/37IGgocUTufhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779189631; c=relaxed/simple;
	bh=OCDehrtsl1MDOn8ZV59hFDVLW1cfpzRbOzVrvGSPSYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwMLtXO52+YSQFK9yG2luEhEl3EQKj/A0JOwSMz/H/SIl9pzlN8qjRp6o+F90mpdcgAJqvZgP4FNqxWzZhr4Ceni3Ptg9F32YVui5OmEzxQeuKCcP4ZnTlffddN8OLWwD+dazTLG+GTjs4iFWvbiEHj5huVA6ONho+Yyn7+CQq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AQIKKu5X; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J32XeU513145;
	Tue, 19 May 2026 11:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=M0GEbL
	bmwoudpZCLHQDug5EHU5yHFWgI2yZbz39W/3Y=; b=AQIKKu5Xi7fgToWbeo+rra
	mPeMMOqsrIzANQd5j2CtV/A+eI18h4QC42PPgsGe+XiTm3oQTjGfjIA0P0sHmV8V
	OYXtiQj7Gwus/ow2zoRsjuDFo1xgIK/NPZQV/MTDt3cBpFWLXOw3eeNamT4RITx8
	SkH64n8ijExzq8xuilV6YGsq1h+SGYLLTReNr3R7+IDvDoQJm5ukv8WIRH/B2AVY
	HJHGA0Y1LWTnWvVVzwCnDPRbN+F+njjm7QPLroRnG9tDiebX/22fXMCixGTXUof1
	cK/MEv5D96VT7mXzahycSjor7/yd1c7lC/BDkJ5l9ZYw12ECx50zqCOBV+lbp/yw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h74vmby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 11:20:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64JB9SZg022760;
	Tue, 19 May 2026 11:20:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wk29v6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 11:20:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64JBK1YL57278752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 11:20:01 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6B112004B;
	Tue, 19 May 2026 11:20:00 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D85A20043;
	Tue, 19 May 2026 11:20:00 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 May 2026 11:20:00 +0000 (GMT)
Message-ID: <bb26a1d7-c5bb-49c2-ba0b-0f435471f836@linux.ibm.com>
Date: Tue, 19 May 2026 13:20:00 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 8/9] sframe: Initialize debug info for kernel sections
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Mostafa Saleh <smostafa@google.com>,
        Herbert Xu
 <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>
References: <20260519064950.493949-1-dylanbhatch@google.com>
 <20260519064950.493949-9-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260519064950.493949-9-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ffCdDUQF c=1 sm=1 tr=0 ts=6a0c4764 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=Zg_fgM-7fzLk7_7bOdYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: osOMUpI1EkLFGz7GpGiXBpaqpCu7CodJ
X-Proofpoint-GUID: oJktVXhhTdy1hCBoDfocItBifulCP71_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEwOSBTYWx0ZWRfX6h44HJ2Sn5m1
 Uts0iVfy8JSpH2hcTPYAJJnEQBU7uoaNBODC6uRaq7duopMCTWdjmqtlzyfiu/EI2sbBUZXM9fL
 QXyH3Nc6dQv+8E1ug8eCSt4UaJ0iaeKp/r/yQo9+krKC0vp1c9zQ0cKSaiw/5N4CVhup7091BZQ
 FW54ypVeTB2oH6hltgTddZL5jRHkd1VgBcBWXpFJsuKtYrMMzNtrJzTGHoqa5iOrb2pj4J5jEQx
 CLjHwQwU8IiK2n2xnI+7ewXJzPt0MH7dzliSjVMJFYoKKKuyTEUMKaxLZuXK7CvY54AVj3ltT4+
 oxwwBgNYSmJTGFCWv53y8DmNucWhNmOc8ZQ8/5AzjJ1sn969nVDya9PryINKMfF1qanfcNU7H77
 /kdbodgZEpGfcPoHx1FRSHFo8Q5upRMhSpSDxyRIi7VJ4sD0MhvvVzs23Z7HcvmUlswCYmXyZOb
 NwHcUWsMLI+Ao4k0iOg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190109
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux.microsoft.com,kernel.org,redhat.com,vger.kernel.org,lists.infradead.org,infradead.org,google.com,gondor.apana.org.au,davemloft.net,linux.dev,gmail.com,goodmis.org,arm.com];
	TAGGED_FROM(0.00)[bounces-2865-lists,live-patching=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.ibm.com:mid];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 9C2F557DF76
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/2026 8:49 AM, Dylan Hatch wrote:
> Setup the optional unwinder debug information for kernel .sframe
> sections. Modules are indicated by the format "(<module-name>)".
> 
> Suggested-by: Jens Remus <jremus@linux.ibm.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

Reviewed-by: Jens Remus <jremus@linux.ibm.com>

> ---
>  kernel/unwind/sframe.c       |  4 ++++
>  kernel/unwind/sframe_debug.h | 13 +++++++++++++
>  2 files changed, 17 insertions(+)
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


