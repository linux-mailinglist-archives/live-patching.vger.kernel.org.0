Return-Path: <live-patching+bounces-2323-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COAnOyF01mkWFggAu9opvQ
	(envelope-from <live-patching+bounces-2323-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 17:28:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 592C63BE2F2
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 17:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD462301A90B
	for <lists+live-patching@lfdr.de>; Wed,  8 Apr 2026 15:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F333D6462;
	Wed,  8 Apr 2026 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IvuKMKQ9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF77039F176
	for <live-patching@vger.kernel.org>; Wed,  8 Apr 2026 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775661897; cv=none; b=Dh5wK6lx/pdrQq6fQ5LjIWqWv8vtYI6fwesWatp74PbSWW6BSxQV0Oto9TQtzjBkSyNY2bHmUYXR2w52bZX7an8vsIbAKPFcHpqq4M+Snx6IpCcNI38+09ApsvqsI7RzFR++nykrXGpu76rYGVXBy5TLq2j0lmS4NIcJ4rzTnFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775661897; c=relaxed/simple;
	bh=Xvx5NbnOpNGEloDoPzkjBb0luYYTDDyuKVmozJ9v8uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LwgM/wORMCcNa1k+Gi3mcwqrqiY/RI742ZNVdbCbLLNfcc4cdex17SDzaQx/q53nQNRD5UwMRovju6uyKeD1CYxE792e5nFlpanJAFgFpePyaRsrvuRguDmAymG+Ge9MYPOj2dgXEfVGt4eaCsGKo0cnu/WaqBvI2yvA7CKu7oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IvuKMKQ9; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso54424735e9.3
        for <live-patching@vger.kernel.org>; Wed, 08 Apr 2026 08:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775661894; x=1776266694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=laiXp2rBEiPl8a2Z73ajRETlDqB8PAbCI44ILQPyqZU=;
        b=IvuKMKQ9jtZ/dVP06vkY7CTiZM4OuHmVnp8SRil2wsw+5I0ykRWCnGsExOFOYPKIZg
         U6Ymn0/O77U8r+O+X+q0jabDGdfKvl4xj/EVc6AbKwQCSaWk7TWUeaiWfTalUFOZIYwj
         UPJFmGWJvvQm1KCG/J4smh5BcB6Glm8/m6U7SDcCyZtDb2okWxp0w60hXrLmar/TF+uG
         MekJaoDfdS/tOTqmOE8U+XkxteSIrZUp/94aBnnQvTa+1ktb38KpLj5hY7MeUbXy0zdj
         /RUTGXZgXYhP2IYM0fqk90rFWks8YnbcCt0VLrYVoKTIjbP0yFZlQ6Zl6euxmwuC8P9O
         TdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775661894; x=1776266694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=laiXp2rBEiPl8a2Z73ajRETlDqB8PAbCI44ILQPyqZU=;
        b=fcEVowhNUlMMrh6R7JmMYNtJ64O4VfNF/EBUDSpIm+ZQUmPt3S/pLhMalZFAIHwav+
         C/ZlL9OqoUEGbm5Ja1/YpXW3jof8jrrwiqxM+5UmxyrwFefxBxqcbuyYvsSX/wiClpqf
         s34jfYLnxjIWLh4182n0vM+AntCXA7Izf8rL5JeKQ04p4SXhsq2vPbW3kBJw38V/csiR
         BZ1pBC+NBFG9cEA4TB6Dtl8x/y7+zf2Ld0YsMRjXw0kAfqoLWAbKsMZBonAYGqc+8/rp
         Reez2bTUzKwvd9jZuUnZZvfGBaEQ+T6Pt34w0urWfzsgxZOE79vTgUA8tpkcwZvZR3NU
         nSKg==
X-Forwarded-Encrypted: i=1; AJvYcCVKzYsa5vMtwtDl7ATGFUMSoNs5gLO6X3r+Gxz5o/TeKML9IvIZqNRIGkn9MrMBiH4t3px2aUVN2BHraudm@vger.kernel.org
X-Gm-Message-State: AOJu0YzeQkhecnKswzYZpYSM1UKlVF2h+ioRoOguvFLcwuPoA42LjT+T
	CB4AUXB+SVNTfdI0oIznQYwbgXt52Nghe9rX50jNX3LigiqJ34nSE1l7aNDLtveen+M=
X-Gm-Gg: AeBDieuPnGQrFpdz1HNf2DSSThKrW51NDrR7Fot/8sG8dMsuXJGKWSM5Wf8zvYDUtdJ
	Ho396zlMKUucdrLov0UCkesf+Km5G0wT2VfnsZTlHz/tJYN/kKlJsuy0NRmV34HqSiZU+93d/x0
	R9CKH5CAFjgd4Z6TAJGuqsC2B4k8RNs5LH0BigbYTj2ODIbZcx1sqyahP3wijSk755G4tQqq57s
	VsvNnWGjZ0OwFilqPIObutfcFazkTIKBKt3ZdQLccGMoTI2EEzxNZKdAzF2ywWotHTMJHKdEwVY
	8jA1DWISUf80U8F15hQD3xfX7BcUr9lZtxj1vdFAOPYPJH97NbAxnej+HO3tZhZ8uTdXEnpFEQn
	+1wuoDDmIorpuEpUoeUHWX7V/+JGLJwKIZ/NAgd1/1BOCQYpTSuJUdN4lc9MSZaCZI6aK1M+JSr
	nkeC6qYxn8Q8ojCfc8U2J20eJOoKDyKB5+/WA6rzPS7dJ8
X-Received: by 2002:a05:600c:6208:b0:488:aa3d:fab1 with SMTP id 5b1f17b1804b1-488ccfc0554mr2091505e9.17.1775661894090;
        Wed, 08 Apr 2026 08:24:54 -0700 (PDT)
Received: from [10.100.51.209] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488cd1bb778sm32985e9.7.2026.04.08.08.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 08:24:53 -0700 (PDT)
Message-ID: <999772c1-ec48-407a-a0fe-64665620d855@suse.com>
Date: Wed, 8 Apr 2026 17:24:53 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] module/kallsyms: fix nextval for data symbol
 lookup
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-modules@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
 Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 Daniel Gomez <da.gomez@kernel.org>, Aaron Tomlin <atomlin@atomlin.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jordan Rome <linux@jordanrome.com>,
 Viktor Malik <vmalik@redhat.com>
References: <20260327110005.16499-1-stf_xl@wp.pl>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260327110005.16499-1-stf_xl@wp.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2323-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid,wp.pl:email]
X-Rspamd-Queue-Id: 592C63BE2F2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/27/26 12:00 PM, Stanislaw Gruszka wrote:
> The symbol lookup code assumes the queried address resides in either
> MOD_TEXT or MOD_INIT_TEXT. This breaks for addresses in other module
> memory regions (e.g. rodata or data), resulting in incorrect upper
> bounds and wrong symbol size.
> 
> Select the module memory region the address belongs to instead of
> hardcoding text sections. Also initialize the lower bound to the start
> of that region, as searching from address 0 is unnecessary.
> 
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Looks ok to me. Feel free to add:

Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>

As a side note, I wonder if manually determining symbol sizes this way
is the best approach for modules, instead of simply returning the
st_size of the symbol. The logic comes from the original implementation
in "[PATCH] kallsyms for new modules" [1]. Unfortunately, the
description doesn't explain this aspect but considering that the patch
rewrote both the main and module kallsyms code, I expect it was done
this way for consistency between vmlinux and modules.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux-fullhistory.git/commit/?id=d069cf94ca296b7fb4c7e362e8f27e2c8aca70f1

-- 
Thanks,
Petr

