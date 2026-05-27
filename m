Return-Path: <live-patching+bounces-2906-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WO0XIPnwFmpcxwcAu9opvQ
	(envelope-from <live-patching+bounces-2906-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 15:26:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4380A5E4ED3
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 15:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B5720300AC2D
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 13:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D06A405C4D;
	Wed, 27 May 2026 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="RUUX7tDA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E1729898F;
	Wed, 27 May 2026 13:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779888042; cv=none; b=bYGIGcBNArE4+THe394GB8/1G3mmNqs0t/AJn2h4aiB4OkZKtRw1zfmrgDhqKaLDW7zkWQcMBYb29Rw3V0rdcn+7OdsHUtamQDNOMYuHxanmcX41/RtN7z5qUQfPT/sbZls8GF0nBAZ8QcO1pXcG9jMdWPgHnPjJW1U0LKk+T00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779888042; c=relaxed/simple;
	bh=L9qKtLQtKkxrsNLnzUtoqvaUZmU05nXO5yp3LacOm6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=auhX5m1yYMPXaN8iTr7TvXwg7S3TQm9h+HHO3UTFWvqvuG6wj/RNH2pMQka1IFP+70wGOahK+Sb1yL0Y9PT5yUqO7qR082r4tqIazutN/0epgYfaywpzBBpIJVVs+QTT7Z+j1YOtrQ59PWQzXPu/dcBz6mz+iC9JxOqyUQBioEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=RUUX7tDA; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779887988;
	bh=5mzZEXyiO0JflCfdB6VaE2FEAlhQSEMBYpDcbwfZk+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=RUUX7tDAf15M+wGnyF+7ZI5GP2lVbFp7/Ud2L5J87ui+kIODLpt1RBajhUVq6IDB7
	 24GghFvXE/8MQ+qRDtpHWG+Cp+2xn5ffQpuJ+QnYgc5Z7dGxjVtktIISLWM4t+Gibt
	 zh2vTGOIzmfSFfUPjIg+AEl9LpbS0GqTO1zg1oVE=
X-QQ-mid: esmtpsz16t1779887978t793583f7
X-QQ-Originating-IP: OniFXumbivWLGG94CJ6pX595nkxTKFJhoEuBCwMMLiQ=
Received: from [192.168.31.204] ( [39.157.100.57])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 21:19:36 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10393737645420507870
Message-ID: <C0D6799DFB309F26+b1597426-6523-47c7-8e22-713819e31f65@uniontech.com>
Date: Wed, 27 May 2026 21:19:35 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: livepatch: set LC_ALL=C to fix
 locale-dependent test failure
To: Marcos Paulo de Souza <mpdesouza@suse.com>, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 shuah@kernel.org
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260527095929.1504032-1-maqianga@uniontech.com>
 <cd470b3b399aa01dfa54a758eca77e58c672d314.camel@suse.com>
From: Qiang Ma <maqianga@uniontech.com>
In-Reply-To: <cd470b3b399aa01dfa54a758eca77e58c672d314.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: Nkm5Fff6p/24clQ5Aah9GBRN5WGxnvVpdOB9yMzRJS3jIC5qJoBC9e3O
	XWW8F9RdN6xwTfXPVjuSd2XvQeT7AtALHIlynllNXoU4+rBw3ewaB18pE5fP5y0pln4txqL
	K0JzpOgZcUn4+T/U+SgnE+x6jbeJRxX3NOPvOXhUvb33nK93yvtLzVkmiLu1+eQCYz6YwdY
	qK+A2b5kgmKn045qkniZ48RTwfjf0dlSsrjJ719aKTAohAv8KOFBZX5U+8RnYf0+JSymTKO
	9GD3mOsi4Yx3gqBYBWwEYYdFgjCK/H0Eh2erp+xu4hylNrcdJ5x9k5JJ6m0yeQHsO4g+WHG
	WUwSOUXO3wZMoW87pBY+tb0VXaheuDtzzPr7vsS2zxptSEmyyDndNDe1a+4RZdtcXSJmeru
	EooGiigRrYJNMGc6rCAJ3UUEQP009rj+ekJHGyFY9QSntWOt8ApEnWvQT4xZXg1KQNuKLvh
	MPcPbgJM7n4b4MUSRRkLzPdY4JISd7YDlqGbyGzYeAn0YuLDth7XRWwHtYQee6kjGz4cwMJ
	nIDB9/AYysMXLqSDj/pxC+FEuMbNzBHxGfkwVAqWNs+Ztp53o77SPTVd/9x7enInWhoaqqS
	7LgHHDWTM32nyXFi+j7WIel9nnObNUBNcEi4WGLgqYMbxHmJ7Ru6Rfdx7pmpKtfaL/VkNeo
	6HWj15wKBUVolbq2tfnTGldbpYPsyBZlZKUbKaKP8TUVjI05Y9so7xg2ZRLDtfUc1p2grho
	qaxQuSn4N5k+uR/INuII0CSRV3latBRinWGKyevgrNdVvCQvNjsOietM6+fAotgo4UeRC7i
	noZeRW5Wb5BnLulyKB8y3HIgFfNXY/BDNtYdnMLpMg3ZRFOKYofpYuwEhvLjSMFJHinbIih
	Uy4juyoCT1hE8R5SQmSe2IHQulcyiRi8lzSasDeEts74hbG1O6kAka3xUhRpUCILw71AIi/
	qGT054gw2Zb3nSND0amA1KUobfELe8pHw4RP7WsoKdMEPgo//sik2QHuefgC75DRcunRP/S
	HtMxdx1LPXAwxfZwrppNGJZb2FmkQW6CikkIAu/7VWRyRcnqY9
X-QQ-XMRINFO: MPJ6Tf5t3I/y7LCPexh/uc8ZoikWzjFzYg==
X-QQ-RECHKSPAM: 0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[uniontech.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[uniontech.com:s=onoh2408];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_MUA_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2906-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[uniontech.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maqianga@uniontech.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,test-ftrace.sh:url,uniontech.com:email,uniontech.com:mid,uniontech.com:dkim]
X-Rspamd-Queue-Id: 4380A5E4ED3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


在 2026/5/27 20:09, Marcos Paulo de Souza 写道:
> On Wed, 2026-05-27 at 17:59 +0800, Qiang Ma wrote:
>> When executing the command
>> "make -C tools/testing/selftests TARGETS=livepatch run_tests",
>> the following error message was reported.
>>
>> TEST: livepatch interaction with ftrace_enabled sysctl ... not ok
>> ...
>> livepatch: sysctlo
>> : setting key "kernel.ftrace_enabled": Device or resource busy
>> livepatch: sysctl: setting key "kernel.ftrace_enabled": 设备或资源忙
>> ...
>> ERROR: livepatch kselftest(s) failed
>> not ok 5 selftests: livepatch: test-ftrace.sh # exit=1
>>
>> To fix it, set LC_ALL=C.
> Would you mind adding more context here? Can you point exactly why is
> this failing inside test-ftrace.sh script?
In the check_result(), the values of  result  and expect are compared.
In the expect value, one part is
"livepatch: sysctl: setting key \"kernel.ftrace_enabled\": Device or 
resource busy".
However, the actual value of result obtained from dmesg is
"[  220.947876] livepatch: sysctl: 设置键 "kernel.ftrace_enabled": 
设备或资源忙".

The comparison is different, so it directly enters the final 'else' branch.
Finally, the 'else' branch prints the difference between result and expect:

# --- expected
# +++ result
# @@ -16,7 +16,7 @@ livepatch: 'test_klp_livepatch': initial # 
livepatch: 'test_klp_livepatch': starting patching transition
#  livepatch: 'test_klp_livepatch': completing patching transition
#  livepatch: 'test_klp_livepatch': patching complete
# -livepatch: sysctl: setting key "kernel.ftrace_enabled": Device or 
resource busy
# +livepatch: sysctl: Set key "kernel.ftrace_enabled": Device or 
resource is busy #  % echo 0 > 
/sys/kernel/livepatch/test_klp_livepatch/enabled
#  livepatch: 'test_klp_livepatch': initializing unpatching transition
#  livepatch: 'test_klp_livepatch': starting unpatching transition
>
> Have you double checked if you had any previous loaded livepatches why
> trying to disable/enable livepatching?
>
> I'll test in my environment, but I'm pretty sure that it used to work
> not so long ago.
>
>> Signed-off-by: Qiang Ma <maqianga@uniontech.com>
>> ---
>>   tools/testing/selftests/livepatch/functions.sh | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/testing/selftests/livepatch/functions.sh
>> b/tools/testing/selftests/livepatch/functions.sh
>> index 8ec0cb64ad94..ecf27c1120f1 100644
>> --- a/tools/testing/selftests/livepatch/functions.sh
>> +++ b/tools/testing/selftests/livepatch/functions.sh
>> @@ -4,6 +4,8 @@
>>   
>>   # Shell functions for the rest of the scripts.
>>   
>> +export LC_ALL=C
>> +
>>   MAX_RETRIES=600
>>   RETRY_INTERVAL=".1"	# seconds
>>   SYSFS_KERNEL_DIR="/sys/kernel"

