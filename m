Return-Path: <live-patching+bounces-2704-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OA8pIeUE+Wm84QIAu9opvQ
	(envelope-from <live-patching+bounces-2704-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 22:43:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B15B94C39F4
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 22:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 92581300981F
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 20:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A004C31A572;
	Mon,  4 May 2026 20:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BXdURoxm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="p4Olimqz"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2412B31717E
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 20:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777927389; cv=none; b=RlnjkZ/yDRF99FU2Ln2OsNszsFgtqk0M5B57JElBJgpF+ekTcneE/1wVUyMIzLZYJWDIZ187B+2tLKP46qbXn+BiJ4V3NVOYkV5NyZKjg7RCFZBWyVlHe6ysGJvo+PTt8T+fJqjgUmlt6VlZ/+ScN0yHGHaBDSEqTYf6H5yiQPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777927389; c=relaxed/simple;
	bh=CKhvfoKac3yTExIwEaM4r+ibd0X1SM6qliORlp2yU1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PUoyWanMmq8iYJWQDJ5R7iAlEvUCmDb+qBv6z+tfre2PWqDLDVujn7R+QSvRAaNQYtb2LE7njTzfBwlKefjpOvPWgdYm+YcgqPYsj0LDmx1ZwDUNHJ2BOjo+Ora++nN8yPhRCJHoqtfGpxFdS9CSKS5vs1fI6vi+28Mq2P3LA10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BXdURoxm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=p4Olimqz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777927386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1GHtRbgMeIDIxOFHs3hsqvzkUilb3wsgu1BamIkvJSs=;
	b=BXdURoxmg0gyDV0OBpOKpP0EJjRrBnedS7iI7b775/iECmQBb0FOUgrCGgZW7SZvIq1o7t
	7uJiImAiC0s+5h/hpNyaScx/wDYIJv0uKlwY1av7ssNmHCJo5w/jS3KFEvirj045FKRmkF
	1V6NT6laEW8QRveZrZYkHQxtB5cyCkE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-aECVAcdHPTSKqHII0JR7Dg-1; Mon, 04 May 2026 16:43:05 -0400
X-MC-Unique: aECVAcdHPTSKqHII0JR7Dg-1
X-Mimecast-MFC-AGG-ID: aECVAcdHPTSKqHII0JR7Dg_1777927384
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8ee9a11aa75so1003923185a.2
        for <live-patching@vger.kernel.org>; Mon, 04 May 2026 13:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777927384; x=1778532184; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1GHtRbgMeIDIxOFHs3hsqvzkUilb3wsgu1BamIkvJSs=;
        b=p4OlimqzRTQiwS0T2PiRI1LTIHiajbVreQlbF2c87HfZ2zTgyQzWJYAlveL+P9QcKT
         vdP0CDu2NPqvAbJHbKuUMmMkOYmDWWkESxnDZaPZalNRR5hfNJ65n/0YCF0DdSxMc60I
         RtHGFXLq9wqsl0n/F36RLdThmyjsCXhoxzXelEpsFby7Xv4LofydUcoJJzgkoGdcdCkt
         jgjQGqVvUJdXADU9txJUItH5CiiOXGsmTpCf7afIPziOVFeVmWifUVGrqVTAv2/qcM2t
         0SI5nj91l07XkkT2IEkjdW4GEWhG1uuz7uM77fH5ELamrHVhP2b6I34Odl2X/3Uv00AK
         Hh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777927384; x=1778532184;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GHtRbgMeIDIxOFHs3hsqvzkUilb3wsgu1BamIkvJSs=;
        b=fBXjPTwH0S4FgPd3IM3Qthvu6NaIyitfvZXjI/h7cgmJ/Vws3QJZeQrKBAmiRaUOj4
         uESjOJwy+6WCgqSOAL6sFC4SFR6lQJFaGmKQtu9HH7DGQH+GsGC/QgssiT7x6L6QwmBo
         i0A5OLSxyKeapHYW14eTah0F7Qo+cY5r2RVY7Z1VegDdJTrifn7B4NajKnSJ/MQZRawd
         qx6jiEjtQMHFm9yZXohD7pWnkwXqA3OF/LhTG/6yqF2JDUSPrwf/reSEywZhP9dDDyx6
         Lshz4izagKh7im1F2Swk6WNT0lOsyKgX53WIBzXxd+jh0t6KEmILSXmOMYmU4pJ98JzU
         4JxQ==
X-Gm-Message-State: AOJu0YwXvjRkkt3nR66PWrkq3R6ScwXRuKThE8rnGjx4JCh/ok/cNHeG
	KZXy0TOilTEpUbecJX4JdsGP1qhTwaeVe1ub8yzi+tSJEQ+mleXLk2gb0EjDrIJvn5jX713m4LQ
	a31hvI6ifYbTqh4kbsIGkflDdMH796Fz/PoxF1R3J1fC4RFUG0/8NEPqep/LVHAB3mUg=
X-Gm-Gg: AeBDietnpS67+9m0vD7ld6hvz94/9yKgxc+SH+YBCb034QaAngMAJ43nPEigOBOOP/p
	IlkrmzpvhjuhJ5u5Ksv8/fR8Be8u/AigJvbSUqJgeAnI0vkEDm/xA9cp9LPv6E5PF3K3GA38Hmu
	sNIzhDvcB4bOCESfel4iWG4b/VgFxIG1mlW4/VR2TpMTEeB+aE1rZkxOsF8dawSJTWsY16nCZ/n
	B2HtK220ygK51ZWlTyrUI64njw589DfcWMdEm7PfkOjb+B+FkiYTdhhIBTh7+rieBCUVtu72SOQ
	1b/OwNdzi/HZsKwQ3sAcfT65E0wWbrqqc3GdaDcBYW8FH6qxTBo7bEdd3plIFSwjHb8RviBIkQm
	FaAiMXlWBnuzVV3ib4FovMVDSKhSXSNtq2t52ylwemPCXhkL9QV/CDed+r8p+bvA/FVDVLuc9yk
	2dk8dTaZnGtKlD
X-Received: by 2002:a05:620a:25d3:b0:8dc:eca0:35bd with SMTP id af79cd13be357-8fd158e5b7amr1588763785a.5.1777927384373;
        Mon, 04 May 2026 13:43:04 -0700 (PDT)
X-Received: by 2002:a05:620a:25d3:b0:8dc:eca0:35bd with SMTP id af79cd13be357-8fd158e5b7amr1588759585a.5.1777927383791;
        Mon, 04 May 2026 13:43:03 -0700 (PDT)
Received: from [192.168.1.26] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc29a7f4dbsm1162742185a.16.2026.05.04.13.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 13:43:03 -0700 (PDT)
Message-ID: <08790b3f-6071-475c-b48f-b517349f2f57@redhat.com>
Date: Mon, 4 May 2026 16:43:02 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
To: Marcos Paulo de Souza <mpdesouza@suse.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, marcos@mpdesouza.com
References: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B15B94C39F4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2704-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[msgid.link:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On 5/4/26 2:34 PM, Marcos Paulo de Souza wrote:
> This is the fifth version of the patchset, which fixes the last Sashiko
> comment, about overwriting MOD_LIVEPATCH global variable and using a
> local variable to avoid module load clashing when an older kernel
> don't support some sysfs attributes.
> 
> Original cover-letter:
> These patches don't really change how the patches are run, just skip
> some tests on kernels that don't support a feature (like kprobe and
> livepatched living together) or when a livepatch sysfs attribute is
> missing.
> 
> These patches are based on printk/for-next branch.
> 
> Please review! Thanks!
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
> Changes in v5:
> - Edit the last three patches to avoid overwriting MOD_LIVEPATCH
>   variable, using a local variable. This fixed the last Sashiko report.
> - Link to v4: https://patch.msgid.link/20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com
> 
> Changes in v4:
> - Patch 5 was changed in order to address a comment made by Sashiko, where
>   subsequent tests rewrite the variables that contain the modules being loaded.
> - Link to v3: https://patch.msgid.link/20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com
> 
> Changes in v3:
> - Patch 1 was changed to reorganize the ifdeffery to handle multiple archs syscall wrapper (Miroslav)
> - Patch 3 was changed to rework the commit message and to address function naming (Joe)
> - Patches 4, 5 and 6 where had the commit messages to include the kernel version where
>   the given sysfs attributes were included (Petr Mladek)
> - Link to v2: https://patch.msgid.link/20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com
> 
> Changes in v2:
> - Patch descriptions were changed to remove "test-X", since it was polluting the commit subjects (Miroslav Benes)
> - Patch 8 was dropped since it was checking for a message from an out-of-tree patch. (Petr Mladek)
> - Patch 3 was dropped as should be treated as expected failure for older kernels. (Petr Mladek)
> - Patch 2 was changed to use y/n instead of 1/0, since it's more natural to use it.
> - Patch 1 was changed to handle ppc and loongson, and error out if dealing with a different architecture that sets
>   CONFIG_ARCH_HAS_SYSCALL_WRAPPER and haven't changed the test to include the proper wrapper prefix.
> - Patch 4 was changed to invert the return of the bash function to return 1 in failure, like
>   a normal bash function (Joe Lawrence)
> - Patches 5, 6 an 7 were changed to not split the tests, but to only run the tests
>   when the attribute were present (Miroslav Benes)
> - Link to v1: https://patch.msgid.link/20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com
> 
> ---
> Marcos Paulo de Souza (6):
>       selftests: livepatch: Check for ARCH_HAS_SYSCALL_WRAPPER config
>       selftests: livepatch: Replace true/false module parameter by y/n
>       selftests: livepatch: Introduce does_sysfs_exist function
>       selftests: livepatch: Check if patched sysfs attribute exists
>       selftests: livepatch: Check if replace sysfs attribute exists
>       selftests: livepatch: Check if stack_order sysfs attribute exists
> 
>  tools/testing/selftests/livepatch/functions.sh     |  10 +
>  tools/testing/selftests/livepatch/test-kprobe.sh   |   8 +-
>  tools/testing/selftests/livepatch/test-sysfs.sh    | 219 +++++++++++----------
>  .../livepatch/test_modules/test_klp_syscall.c      |  27 ++-
>  4 files changed, 153 insertions(+), 111 deletions(-)
> ---
> base-commit: 712c0756828becbfc629ff8d8b82deff5d1115e4
> change-id: 20260309-lp-tests-old-fixes-f955abc8ec27
> 

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

FWIW, I tried this out on 4.18.0-372.137.1.el8_6.x86_64, the oldest
kernel we're supporting for livepatching at the momement, and the modern
selftests + Marcos's patchset happily ran without any problems.

-- 
Joe


