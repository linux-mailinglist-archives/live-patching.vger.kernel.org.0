Return-Path: <live-patching+bounces-2425-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6MfkGoTb6GnOQwIAu9opvQ
	(envelope-from <live-patching+bounces-2425-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 16:30:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CE03D447419
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 16:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56A3F3073D69
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 14:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB17373BE0;
	Wed, 22 Apr 2026 14:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tz503uFG"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658D254768;
	Wed, 22 Apr 2026 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776867943; cv=none; b=JSNCPoZMiRck9lYcIW/5KFwcALrjlInuGb7iWPutMBSpgg09gdu0L3CD/XPFQ9E9vxPWpDcxKVcDZq3/bacp6ktIY+uO8AK3qxhc0f4uxQY+NftKWgBpd9R4WMi7yno4ZpyVerBLkJFWVnw/JuW9pxRGp2IB62K/SXqPKGKwRxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776867943; c=relaxed/simple;
	bh=Ms6O2Y759SQIQI67GM86wKOgEqh2dfrLNAX6Fvd846Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=exO36ErVh2ZZl+sMsszTmhfblOMSlhk4lFf9Eu7QfHar00x22vQnM2ewbSQrFqp6cN5l+uLRiCpS7eKnYvpN2Mqmnap6uI4FK5csG51ISROUlxPY70wpq3GAZR7jM13ygSXznyuvVGp5NnTuNqIzRte87mYkIv7P4Y0ZHZLg/tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Tz503uFG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MBj78v877918;
	Wed, 22 Apr 2026 14:25:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SUhj+R
	IVSg0xcqvFOYPYWSktBAAgbl/ma9Z7cuiNCXU=; b=Tz503uFGHuzECVTQpHc60z
	Q4GJqs00UIgfBdYOAAX2UHTcxvyxywcWqTtPwoBZ+cmRcqX4pyhZajINyH6FN4os
	FAy9iLkY7XhVM6Qt19j/zKgULFoglyx3s80OFc1ek6QGKMvQKgMozLNq7QAn4kCA
	uTymwYniV9b9OORBWzlHhczNGUl3mvIzS8XCrO/sgATU2PNZMsNQ7X75aHkQqMtJ
	mXj2ggizqmQASzjIpF19CDELq3kiegBqC5/5msMHrrnkTOw0ZqwqMrtqoLjFRb+p
	bHiPbWGKF3nSujxjLswbePedh+1gwFsKTQ1oyLwPOIxGPZsH0Qnhkw/H2AYkoeXg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu23xfg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 14:25:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63MEKIeB021096;
	Wed, 22 Apr 2026 14:25:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjky2ju3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 14:25:14 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63MEPC7D31064812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 14:25:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D4E920043;
	Wed, 22 Apr 2026 14:25:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDFBD20040;
	Wed, 22 Apr 2026 14:25:11 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Apr 2026 14:25:11 +0000 (GMT)
Message-ID: <b2bb636c-d471-4ead-8b3a-73145f313a6c@linux.ibm.com>
Date: Wed, 22 Apr 2026 16:25:10 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames
To: Dylan Hatch <dylanbhatch@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
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
        Randy Dunlap <rdunlap@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20260421225200.1198447-1-dylanbhatch@google.com>
 <20260421225200.1198447-9-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260421225200.1198447-9-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDEzOCBTYWx0ZWRfX2kvMUk3S+OC+
 gqFoNEEhtnRg9VQeED2eCxTxjFLsq8P5YGGtBn3MZYMS6Ncda0aTLHMQxGdkwUD8gHCd4JHndY2
 77je2Qk4nyZh0wv1gm2Rvtm0Qzr9rTpbqaPe0ijIH2Eipdd5hU4Z4XoNhDbNTuwkkEnV4NR/q7p
 u91zqcrMn5uyEUDuZ22tDazhCFYiGFonecYD7t+a3GBiqb/80VZ05XZV3jRUSyNkQOXVg3DuaRb
 8y3WxBmDo+6aRRY1SmDkoxDe/fwu4n9T0wJHQ+6lZW4WFiKqtbfYU60+GHmaPeJCIfz0fO0cAXS
 OQpefQBPZvHofh84JCgHUuTcaXTTHrYJwF67Z4wzPQOm/fMlLgukqjeg+Fr3pPGSPoefZKRM9W8
 p1X5IW/V5NQcz5iK+v5NfgDmg6OpHEfHfK3rK87mzhJzl+BZRGbu9SPoN0a94BSS889CSNLhllx
 fNBGFVnqJePkDtipz2A==
X-Proofpoint-ORIG-GUID: b9RXQHKk6qny2EpuC5nOWztOld29cGVI
X-Proofpoint-GUID: bIq9vOzF3LjsfNMvyWIsol4Xu-ODlMMw
X-Authority-Analysis: v=2.4 cv=XMUAjwhE c=1 sm=1 tr=0 ts=69e8da4c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=yMhMjlubAAAA:8 a=cvgsuMldqgkNetmmUx0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604220138
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2425-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[google.com,linux.dev,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
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
X-Rspamd-Queue-Id: CE03D447419
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/2026 12:52 AM, Dylan Hatch wrote:
> Add unwind_next_frame_sframe() function to unwind by sframe info if
> present. Use this method at exception boundaries, falling back to
> frame-pointer unwind only on failure. In such failure cases, the
> stacktrace is considered unreliable.
> 
> During normal unwind, prefer frame pointer unwind (for better
> performance) with sframe as a backup.
> 
> This change restores the LR behavior originally introduced in commit
> c2c6b27b5aa14fa2 ("arm64: stacktrace: unwind exception boundaries"),
> But later removed in commit 32ed1205682e ("arm64: stacktrace: Skip
> reporting LR at exception boundaries")
> 
> This can be done because the sframe data can be used to determine
> whether the LR is current for the PC value recovered from pt_regs at the
> exception boundary.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

Reviewed-by: Jens Remus <jremus@linux.ibm.com>

> ---
>  arch/arm64/include/asm/stacktrace/common.h |   6 +
>  arch/arm64/kernel/stacktrace.c             | 246 +++++++++++++++++++--
>  2 files changed, 232 insertions(+), 20 deletions(-)
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


