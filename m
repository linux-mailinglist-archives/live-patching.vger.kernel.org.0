Return-Path: <live-patching+bounces-2401-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wP/eFTDn5WlkpAEAu9opvQ
	(envelope-from <live-patching+bounces-2401-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 10:43:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 009DB428550
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 10:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CE3BA300BBAD
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 08:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53B1388378;
	Mon, 20 Apr 2026 08:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lpDofpzt"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0612E62AC;
	Mon, 20 Apr 2026 08:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674601; cv=none; b=Ht2sXxMRr7uYS/ek/DRhLtExE0eAvLRMjGTFuqEwSB3MRUXp3GbRBPXv0idB7JAgOdAFxmiN1UIN4WwbGm8vzqAhudMJ5wP93DSM4Sy66HhRzKC7o+HVipgpiZ/satx/HDhDJcLPO7+UdQG8AnzjeC84ce5Mz4Hs820nFIMbXoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674601; c=relaxed/simple;
	bh=KamnWGuQSffYy9x49OkeaOXECzZHN1QFsKAU5EZkr/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rKJYdiXCMrgI0bOTz7iZ4HmUuu4nVPi1DTRUnEYO5DkuMMG83Nuv7xZsMMFMBZd504C7yFNLXUUVZyWvKogp75hhZkGuy16YHV1CanlxnoWN6fS0fcV6ewOd00NBFrFbhaRbmJ7fjr5KPPXrWIM60/okbRFrkZbo7qwT1jVKaks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lpDofpzt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JKbMQw3328104;
	Mon, 20 Apr 2026 08:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WtAQ5n
	espRadwMvnwiXY7YJQC/MnrHSYrYxhN6nze7I=; b=lpDofpztFtDwXoeQcJzIj0
	8rABpaVRS5+5/Tjo+jRIUM4Okxk8XH3ZnMYUmbhMuhlHJYIQ2p+nyT0lYWMn4v8z
	0X1ul1e4Q3S01AYfQy8r7gASICC4nQ55z8nOlE0bj8PcXur3su2pkolWkaQIzDrm
	h9doLym4ROVuI1/fOVPamVlrAlJNwunaTO8rJSIPmCtWwPU0rTiSIrTLAedBULoC
	vhBRp95mFBJloqc8uu6iWrV0gFIVEAIFc8bzkUo9s7iUHU8GtdClkHdX/U5jN37w
	klCehLWiXhDBwyFCJrWFLLe5HcFujmwylj9fT9bvUP/erRAct9GNzjjPkpdOfsCA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2nexyp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 08:42:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63K8ZUqx030654;
	Mon, 20 Apr 2026 08:42:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dmpyxussy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 08:42:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63K8gbeh49611118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 08:42:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAA7A20043;
	Mon, 20 Apr 2026 08:42:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B4042004D;
	Mon, 20 Apr 2026 08:42:36 +0000 (GMT)
Received: from [9.111.165.155] (unknown [9.111.165.155])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Apr 2026 08:42:36 +0000 (GMT)
Message-ID: <fa27b683-d291-4f1d-b11d-3e178e5f578e@linux.ibm.com>
Date: Mon, 20 Apr 2026 10:42:35 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames.
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>,
        Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Heiko Carstens <hca@linux.ibm.com>
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-9-dylanbhatch@google.com>
 <95f9d11a-dd92-433e-a8db-cbebe94e1611@linux.ibm.com>
 <CADBMgpwjDf44p0ApR1=XVStCyN-0Q6tuywJ4ixLcbaLZOSjjBg@mail.gmail.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <CADBMgpwjDf44p0ApR1=XVStCyN-0Q6tuywJ4ixLcbaLZOSjjBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: fzGFf5xC6qPPmew3PdEDoQXPPZnPkVLi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA3OSBTYWx0ZWRfX7FawYZQxbNSN
 Qf5nZEkKh5Inn5raHnrzNTbahFHEVKRATu8Vr10un/rsioaw+UfOa6+S9HrzIR2YimZa4u/0EHP
 Z0cZ53uOyCagH8e2kH+5W+N27cHW2MAyOv49ljYXugp7DwH9Rerew3HH6SCkY3FAlv+nzSZDlpN
 PiYrOHugV1Y9HA7VB0xNK//Rb0AkmxMbUnPChazKpF53z4RJ45MAaGVyEZOJOpmWKoTqfCGaHVY
 q24MMy7NYx6Qv/qyXiQqG8T2X6gN7eCffVL5nfc3Cw1P+cP49eLe7x0Jy09HW9/C1kn/yBPnhaB
 H/+GxEPPS3TJAXK8y4eG5xq6THUBBtvo66hmn+OTGa/kH8rabmOWlw+sVG+R65tweGkrWANy+6o
 zSrstjn30GnUwt7Beu1pFRSSbhV+1Fh0XTUEbtHVbFpMb07BOspeMyttj7CbMBFUaqYCeNiCvPN
 oC90dkkIC7MIpXo11gw==
X-Proofpoint-GUID: lKZ91ibTxh7IZta9vbAZRx6-JC85qujN
X-Authority-Analysis: v=2.4 cv=B7iJFutM c=1 sm=1 tr=0 ts=69e5e701 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=Szxg4tLUPHRwUYXFK54A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200079
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2401-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 009DB428550
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/20/2026 7:56 AM, Dylan Hatch wrote:
> On Fri, Apr 17, 2026 at 8:45 AM Jens Remus <jremus@linux.ibm.com> wrote:

>>> +     case UNWIND_CFA_RULE_REG_OFFSET:
>>> +     case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
>>> +             if (!regs)
>>
>>                 if (!regs || frame.cfa.regnum > 30)
>>
>>> +                     return -EINVAL;
>>> +             cfa = regs->regs[frame.cfa.regnum];
>>
>> In unwind user this is guarded by a topmost frame check, as arbitrary
>> registers are otherwise not available.  Isn't this necessary in the
>> kernel case?
> 
> It is necessary, though as you point out the way I wrote the check is
> not as obvious as it probably should be.
> 
> The saved state->regs is set when the current frame is recovered from
> the saved PC of a struct pt_regs, and then immediately set back to
> NULL after the next frame has been recovered. In other words, the
> state->regs is only ever set when it is relevant to the current frame,
> which occurs when state->source == KUNWIND_SOURCE_REGS_PC. This only
> happens when the topmost frame is recovered from a pt_regs, or when a
> pt_regs is recovered from the stack due to an interrupt.
> 
> I can make this more readable by adding an explicit check for
> KUNWIND_SOURCE_REGS_PC in addition to state->regs != NULL.

Thanks for the explanation!  Maybe just add an explanation to the commit
message and a short comment above the (!regs) test?

/* regs only available in topmost frame */

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


