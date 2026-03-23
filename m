Return-Path: <live-patching+bounces-2251-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOq5KVg9wWk9RwQAu9opvQ
	(envelope-from <live-patching+bounces-2251-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Mar 2026 14:17:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 614852F2ABD
	for <lists+live-patching@lfdr.de>; Mon, 23 Mar 2026 14:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 77B6730B0E59
	for <lists+live-patching@lfdr.de>; Mon, 23 Mar 2026 13:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21EE1DF980;
	Mon, 23 Mar 2026 13:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CWoWw0kO"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A781E0E14
	for <live-patching@vger.kernel.org>; Mon, 23 Mar 2026 13:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774271207; cv=none; b=lgJNwT2MfCqRc0xEoRlcnA0ZvuaA+PswGO0OG01I4RgAiE1m41EFVckl0g7YC2KvYTtNH0xZRpcdiz+RHUoHwCkvBBGS1pPQKGfKOQA+TD0jqR121jYxLl7WK7wh95KYA0NQF8QEtsoT0U0a1JH7pjidRwmLaEln8D/lXleVOP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774271207; c=relaxed/simple;
	bh=MyPj7IilmsOkQbPJ0UsoFWuSk6o+6Jy+Fsm+s2cZ70g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SOp+77kt+aq0Tsul75NUkxRKJ/8J4kowdjMUr8ljEUF5OJ64g9Z6tIkzsHqh3vDnyv54P5MWRDPTBeklDA0QWw5QM/zGz71CRzy6F0Ml6hkgBAgyokJavL+4hWw7hMfv2HmIKsjN+EljusrzCUXIHlobKyEOWp9D8ltyVzX6Xa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CWoWw0kO; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486507134e4so1469865e9.0
        for <live-patching@vger.kernel.org>; Mon, 23 Mar 2026 06:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774271205; x=1774876005; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M3gKprxO6kW+gnEONjHAGOtiSkxzFKPQeFPHkZURXxg=;
        b=CWoWw0kO4+wgMLumIHjt9NUjfOlw2QY5IUVwapeASjcM9zW/eyuwoREsXV7f41TZ0P
         fCIMy5QKc77hZLJ7/uwIDhNO/hKo/4nOfQU7hRzhNz8wB6JEBcbwVeDdkN6it/fRuwqN
         IzfMUhc+hCs+lHE6pB+LpnhXSOJHVmO0ePz2xMgq/WgvqMuWkF/+OTxw/0I3lp8xjBZi
         dtzMg+JlZaMf7zXFHIuG3KLQ4hwgh9zlCXP/bRa8Vdr2N256JLyn7dccy8YAHjT5Q0h0
         xwRhvw8mR2WC6zD6zIz+1PufXGV8xRTTyJVMt8s+XkPBdtJwwSkuwlXovOBTy83El7Do
         1Z3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774271205; x=1774876005;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M3gKprxO6kW+gnEONjHAGOtiSkxzFKPQeFPHkZURXxg=;
        b=C323IEWd09QQl3h4m9R6RDu+0eJxgJHqnM5cqxuDg/vj7REYG7SDamC6s1sGJpHdKh
         R+N0je04ndIFt7kVKOVZD2L1ukwNTI/dyhlyDMmTWQcpdnA/rOd6lvu66DJTIyx3K7gy
         qGp7Wq8F/oND9GI9Pu8LgR4BeHUP0nPjHP7lxhnIq+55ELP+SdqOXHt7YxvXTY7aO4+U
         dz9ePKTB9Dgc33otLLc/AsY6KJnkDVu8fJwuboEZK1FS0QOLAVgkO+ECPXsd4EearuGw
         gKGwF3FuaRq6SPk8utq2k4c8sVAYGMJA+Y1Hy356ZXv8VDfW0uHopoJId1WxlZfvdOmP
         q3kw==
X-Forwarded-Encrypted: i=1; AJvYcCWjZjfR5CjwdGQNG8mOeJmoPxhgOJ+mApKZfIpCMzE5zqiYGROYqHNLRyxEp+Yifromo1DiQRZ744D0s9Oy@vger.kernel.org
X-Gm-Message-State: AOJu0YwUVca2nfF3pWmlGSpKms/MAVHgjauqeRH6pdGprh5HISmN2gGr
	jyxpj8dtjN53rEKu0k+Vs17CxzsVx15JLr4cpVWHHJTMuptxRrzfPHXshZp0aqNgTYNnjik92d5
	xzK0P
X-Gm-Gg: ATEYQzy5+g07PXqn+866FLAVxyHlwjkMYKePhjOQ0KAanc5ytno2YhkLC0Cn+ozRWUD
	94X0RHURIQ2rPTCdgPKXO57P1DC+tVT4+xgr05qD3k37exa9NCATM9m+mUPyQIuB6sJwd/0RwUO
	oxdY7PXrO52cKsT0U+/bAuAM1qvJZY64ANtX40GCmiwHCJH2ZID7naUEbutItJl0x2TVdN0jtM+
	5A821yu4wgy7MNZOKAIvl9u0hGQpsobLjbDqOyfBoojhejkByP81/PzV+tJLvKBxeMPq1Bd8RbT
	48/d1LU6bX94kgTZ/JuWGS/IGo2wCz5fB1F7tV23r70UBRqaS66UfauwCzgMAY5EBFU8jznZWpC
	k5PTamUWyw8TMo+7CUwaDs2Gki3hsK5fKQoQIpGP1c6mNBwDAidhcwRnOLaLqX0Wvcel2eyVTJH
	IxDPgQNl/GBNIKKVN9WrBe+uO/kqqJcajjNI6eTU1AsdHN
X-Received: by 2002:a05:600c:3b07:b0:485:3aa1:a7f1 with SMTP id 5b1f17b1804b1-486fedab4bdmr170699615e9.7.1774271204664;
        Mon, 23 Mar 2026 06:06:44 -0700 (PDT)
Received: from [10.100.51.209] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486ff1c16absm79866135e9.26.2026.03.23.06.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 06:06:44 -0700 (PDT)
Message-ID: <b6030f42-b4d2-4e52-acec-76e25c0f40db@suse.com>
Date: Mon, 23 Mar 2026 14:06:43 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] module/kallsyms: sort function symbols and use binary
 search
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-modules@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
 Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 Daniel Gomez <da.gomez@kernel.org>, Aaron Tomlin <atomlin@atomlin.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jordan Rome <linux@jordanrome.com>,
 Viktor Malik <vmalik@redhat.com>
References: <20260317110423.45481-1-stf_xl@wp.pl>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260317110423.45481-1-stf_xl@wp.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2251-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[wp.pl];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:dkim,suse.com:mid,nano:email]
X-Rspamd-Queue-Id: 614852F2ABD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/17/26 12:04 PM, Stanislaw Gruszka wrote:
> Module symbol lookup via find_kallsyms_symbol() performs a linear scan
> over the entire symtab when resolving an address. The number of symbols
> in module symtabs has grown over the years, largely due to additional
> metadata in non-standard sections, making this lookup very slow.
> 
> Improve this by separating function symbols during module load, placing
> them at the beginning of the symtab, sorting them by address, and using
> binary search when resolving addresses in module text.

Doesn't considering only function symbols break the expected behavior
with CONFIG_KALLSYMS_ALL=y. For instance, when using kdb, is it still
able to see all symbols in a module? The module loader should be remain
consistent with the main kallsyms code regarding which symbols can be
looked up.

> 
> This also should improve times for linear symbol name lookups, as valid
> function symbols are now located at the beginning of the symtab.
> 
> The cost of sorting is small relative to module load time. In repeated
> module load tests [1], depending on .config options, this change
> increases load time between 2% and 4%. With cold caches, the difference
> is not measurable, as memory access latency dominates.
> 
> The sorting theoretically could be done in compile time, but much more
> complicated as we would have to simulate kernel addresses resolution
> for symbols, and then correct relocation entries. That would be risky
> if get out of sync.
> 
> The improvement can be observed when listing ftrace filter functions:
> 
> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> 74908
> 
> real	0m1.315s
> user	0m0.000s
> sys	0m1.312s
> 
> After:
> 
> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> 74911
> 
> real	0m0.167s
> user	0m0.004s
> sys	0m0.175s
> 
> (there are three more symbols introduced by the patch)

This looks as a reasonable improvement.

> 
> For livepatch modules, the symtab layout is preserved and the existing
> linear search is used. For this case, it should be possible to keep
> the original ELF symtab instead of copying it 1:1, but that is outside
> the scope of this patch.

Livepatch modules are already handled specially by the kallsyms module
code so excluding them from this optimization is probably ok.

However, it might be worth revisiting this exception. I believe that
livepatch support requires the original symbol table for relocations to
remain usable. It might make sense to investigate whether updating the
relocation data with the adjusted symbol indexes would be sensible.

-- 
Thanks,
Petr

