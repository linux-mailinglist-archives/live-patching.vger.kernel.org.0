Return-Path: <live-patching+bounces-2408-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GP8FM4w252mg5QEAu9opvQ
	(envelope-from <live-patching+bounces-2408-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 10:34:20 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B4C438391
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 10:34:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 40BD53004DB8
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 08:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013343815DE;
	Tue, 21 Apr 2026 08:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JMm1DwLu"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A905835DA75;
	Tue, 21 Apr 2026 08:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776760451; cv=none; b=uX4EXwj5vg5fUwY7z0hHyvhOPVvYqxBazbAmr42sV8wY0HScMjWLkNhQYTB9Ng+eJ/M9r2ANLq0xhYqbS0m5wvgJbqp5pvK9/CFr9HyLoWnsOWAJtmq0YooV9bjAO04FpdZAu5XlHNdvUZd6OnZZAQUgZFEtnju8NmeYjTqrAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776760451; c=relaxed/simple;
	bh=uSfxKRwjpew2HmTRfW08i9EUnOP8Y7nhJIo6xFpeKYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FOCkP6iDWrAXQMTcNgNkSQvhl1tb+E73eoq3vIqoUmnaGITsIWQielPA2Zj2XdWyAWTAJ/3rnyeOeDa+yJE4smY9VvbL1lOrBE1oiZ4Y0wGL0lgnniIEz9YQihWYqrOlQgOF3a6jpa3cuQty3VNrCQB1/Rbg+O3nsWcTCUL2hhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JMm1DwLu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KJgrTX1651159;
	Tue, 21 Apr 2026 08:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tvgU+J
	+uG4qVRdJ0fs/rTSKY//EETVDv8n341qcJESE=; b=JMm1DwLugRh9n3Pzk8PG/7
	RBeu/h58aiVtiO6x87msc+X3di6kQBA0LPSn+GqnnDwrpsXitVaBqpL8IJWsQu6+
	4eBryUILfdzsk8kHKksN5yXGDYJ16pKxWNQBjR8/Uu/ribCiI881dqewEU8p2iCe
	hRk7k/xOaGhWgzPUHiPXQ/f/Ucl+THWL5qQe2Pp3K2waoDSXxgnbx3yhOEY3xtz4
	NmgPkB7F+9gPRel114P+1GMyEHmMvhOFBcxIPqZG3l1f6T+aYf0VNzx/ZPcoo/W9
	0iZNrSo5PtvHtQ//g48GgY/SWHF3FAzGhE21PR7Za3LbwiclnjkSa/YF/jd7cq8g
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k53d5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 08:33:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63L8KNho017504;
	Tue, 21 Apr 2026 08:33:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmmnvr3pf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 08:33:32 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63L8XUBL29557270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 08:33:30 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C24220043;
	Tue, 21 Apr 2026 08:33:30 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16AC920040;
	Tue, 21 Apr 2026 08:33:30 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Apr 2026 08:33:30 +0000 (GMT)
Message-ID: <887de7b5-046c-4f68-b44c-8a1aaf2635e7@linux.ibm.com>
Date: Tue, 21 Apr 2026 10:33:29 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION.
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Indu Bhagat <ibhagatgnu@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
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
 <20260406185000.1378082-8-dylanbhatch@google.com>
 <de7bd273-3650-4378-8fd8-a51217e7284b@linux.ibm.com>
 <CADBMgpzbEGTm-sZ71a5hvFOHbu5VgSR406F3NsMLF1+oDWbO6A@mail.gmail.com>
 <dde1daa9-724c-4186-aaf6-caff6b47c5a9@linux.ibm.com>
 <CADBMgpzBvKTvRKHmLbEF301S_DnCg6SRETkMh6jPo-1hOEEZVw@mail.gmail.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <CADBMgpzBvKTvRKHmLbEF301S_DnCg6SRETkMh6jPo-1hOEEZVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 0l_0RsB_xVUM48Vi_xszwbiWIKn94MiD
X-Proofpoint-ORIG-GUID: oLmmSpz0tjomWJLPkahKivQ_qCrtNnAk
X-Authority-Analysis: v=2.4 cv=VP7tWdPX c=1 sm=1 tr=0 ts=69e7365e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=LFt20mCCc4CE-LtB3JUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA4MCBTYWx0ZWRfX074kI05iuZWX
 OgF+ppwk0jYBKZuP91sOou6vhfh7Y1EsTO8Lr2UCkwBgTT6VK25UiXfJ4dtQ9wFMtQHGQxlgdet
 oN63gcciIX/G7lfkL40WjskQSC+oXC4L5BEO0HkmnCLjFZICQ9sU9iCvjCMBlNCR7AUKnQ1NrxW
 hCHqaZR5ajpEvhwbLNVC1sm0WJiIlG0KNR87SjudIOtEfnfln4fyWNNrTukrNfD5/1C51ftwJ1C
 6eaD+BjjfwmHEmaXZ6Gh65Y0GsfiNQsRx8hL9E7uE2wGPzI1utdwm2/yeJZRrfWtCfex8q6nvGJ
 aG8qUGxZmuH5ytYEs6nTrN4r40xZYAQ+oMq7Lo4QIKpY0sSh1Ls9naD/IZxmk7+7Fa/zD+cX8cy
 airZxFY0uA5K6kp4/ppqgPig7vxQAD85MWSMYIJO2FU7KMAx3gySUmvPQzQYZRp56iN9NQIybNL
 hb0ja4sy5LL4XCVdNlA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210080
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_CC(0.00)[gmail.com,linux.dev,google.com,kernel.org,oracle.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	TAGGED_FROM(0.00)[bounces-2408-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: C7B4C438391
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/2026 3:29 AM, Dylan Hatch wrote:
> On Mon, Apr 20, 2026 at 5:31 AM Jens Remus <jremus@linux.ibm.com> wrote:
>>
>> On 4/20/2026 7:02 AM, Dylan Hatch wrote:
>>> On Thu, Apr 16, 2026 at 8:04 AM Jens Remus <jremus@linux.ibm.com> wrote:
>>>> On 4/6/2026 8:49 PM, Dylan Hatch wrote:
>>
>>>>> Generalize the __safe* helpers to support a non-user-access code path.
>>>>> Allow for kernel FDE read failures due to the presence of .rodata.text.
>>>>> This section contains code that can't be executed by the kernel
>>>>> direclty, and thus lies ouside the normal kernel-text bounds.
>>>>
>>>> Nits: s/direclty/directly/ s/ouside/outside/
>>>>
>>>> Could you please explain the issue?  How/why does .sframe for
>>>> .rodata.text pose an issue for .sframe verification?
>>>
>>> __read_fde checks that the fde_addr it extracts is within the bounds
>>> of sec->text_start and sec->text_end. In the case of the vmlinux
>>
>> Looking at the existing check in __read_fde(), do you agree that it is
>> wrong, as sec->text_end IIUC points behind .text and thus the check
>> should be:
>>
>>         if (func_addr < sec->text_start || func_addr >= sec->text_end)
>>                 return -EINVAL;
> 
> I agree this is correct. Is this a fix that would be folded into your
> previous patch series?

Yes.  I would send a new version once we have clarified how to move
forward in general.

>>> Alternatively, we can check for FDEs located
>>> in .rodata.text during validation, but this seems to only be present
>>> in arm64, so maybe we would need an arch-specific hook to do this? I'm
>>> open to suggestions.
>>
>> Maybe that is better than ignoring __read_fde() failures?  I first
>> thought this would get nasty, but maybe it would not be too bad.
>> Following is what I came up with (note tabs replaced by spaces due to
>> copy&paste from terminal):

>> diff --git a/include/linux/sframe.h b/include/linux/sframe.h
>> @@ -63,6 +63,10 @@ struct sframe_section {
>>         unsigned long           sframe_end;
>>         unsigned long           text_start;
>>         unsigned long           text_end;
>> +#if defined(CONFIG_SFRAME_UNWINDER) && defined(CONFIG_ARM64)
>> +       unsigned long           rodatatext_start;
>> +       unsigned long           rodatatext_end;
>> +#endif
> 
> It looks to me like .rodata.text only exists for vmlinux. I wonder if
> in sframe_func_start_addr_valid we can just use the global
> _srodatatext and _erodatatext after identifying if an sframe_section
> corresponds to vmlinux (kernel_sfsec)? That way we don't need to add
> these extra fields.

Sure.  I don't have and preferences.

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


