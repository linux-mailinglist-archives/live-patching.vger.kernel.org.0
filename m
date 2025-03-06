Return-Path: <live-patching+bounces-1258-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 636A7A55A38
	for <lists+live-patching@lfdr.de>; Thu,  6 Mar 2025 23:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B0C116C981
	for <lists+live-patching@lfdr.de>; Thu,  6 Mar 2025 22:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AAFB27C85A;
	Thu,  6 Mar 2025 22:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ACHmYmus"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FCB206F22
	for <live-patching@vger.kernel.org>; Thu,  6 Mar 2025 22:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301700; cv=none; b=e/wW+OqbmEuEGLCe6t7Wnc5/uqL2shle6FC/7gXUpNc22O+Zb8elBbV9fsBb7TxQmhK7H6auldUwFry6MWEG0o76bxERH96gdJw2/l/1wBQQ+0e5eEXvPNRLkuigHiKNCOTa7Xr1tG4ygOXohqaNFtYeL4aqSprnAhnBDFF4v2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301700; c=relaxed/simple;
	bh=Ec2v/6+I2m2dMEutWSk/xRKfwD+T9KZtIxeor2olnSM=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=BjsXE832krcXsLpvHq8CrjnEe8xV7VNKO52+725vIIXWHMCa9eRHs3jFcOjxRD1RCYNI/5oM2/aFeZeituFH/WcfSYBjnv7SA2Qfs6GVCgm8bj+XiOtS9Mt5PCAbodm1Ezl2pHX5PE2omtSNM2sy/NrUDgGXxQRUXl7tRJZIuXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ACHmYmus; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741301696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSX2Ub1CKLDkvugsqLVThWkv/Fyhg59pKvv3HTVRtQk=;
	b=ACHmYmustdwRhCoo6/LknI7IzmefJOyY/HnwxJJ/JNryACokbRDkTk90SLrNBXZ7aCIb7V
	j2tT0gWZhS7Qxj6zJtAQqDklWqy/bhgmZWiVUvhu0Rk9XGdKO7JfpSf39+pFTHQcPRhhCs
	ObsUDMM/fUDdbCV0ZFGL6NdjsyL4jwU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-SkFm9CrdNXKFgYpjH0Y66Q-1; Thu, 06 Mar 2025 17:54:45 -0500
X-MC-Unique: SkFm9CrdNXKFgYpjH0Y66Q-1
X-Mimecast-MFC-AGG-ID: SkFm9CrdNXKFgYpjH0Y66Q_1741301685
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6e8f9450b19so21489676d6.1
        for <live-patching@vger.kernel.org>; Thu, 06 Mar 2025 14:54:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741301685; x=1741906485;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSX2Ub1CKLDkvugsqLVThWkv/Fyhg59pKvv3HTVRtQk=;
        b=AzA7o/9ShybMBVE/bXQLitJmySn61klUb6itjyjaScDUwjUvb2B+sv/5+ML1bntR6F
         OrWZ7rTSl1N4cKq2q0L6s6SEU5LjkzNHN7nm93Jvjd7PCv2VVscPthaWod3r6eA7b8cb
         75/qsMBWSZqXJlUEmnuz3D/7b01tjE4haGqgIsbQC6Dw8uSd/bH1KOtT00AOq5TIiKV8
         4NE1DpMnY5MzynZRuc7mkCgsAO3nwVlKemBktTL9kebwVRdUuLrPfYU6Bc9li0Gd/hGP
         2OA+HzqQNUps765KqVoQ3lX78tUrqRpiw6VLQFl4XSK6XgzKAORNHcmtQWAefxmGAai8
         f9YQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCO5ARoTrT/TPLqzSUa0ArlzrHcni0r5hZsZfl/JQJi94NBynmdJLSJ8zeS/oOji0b7hwP3R/Ry9CYFEqX@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3FXPZXRnKqtl84s/OkSNC1TzrBx6UeasdRz6BJMc6ZcZKPapL
	Rn9d2Uhv4fpOlLmL40sB4ZaV//Z16f1wlcUkTzkumX9ejpcqJDNQfPjzya7OTAGYA9YfuVVdKCt
	0rrXOIFomkVylb4+UmikL2eQ9rSGUwaUDXbrJL4Sllmk1zsJJzhxPq19yb09VeXE=
X-Gm-Gg: ASbGnctGzja984x/g3rblnMUGwFNfX//fXvZS4bj3ENVX0tk4UlDIYNSJgJdJ59XwIh
	oB0KMp2eIAhJjbQwrje037n3etFBtvLZZBbjITKAkMd6klCvACsAyFHHVHhJSUkxa7hMDgMVqQa
	EXKgLJmCCZrZsQp4ocAeV0VpimtPkftBV37hNXQBLP43WTmekNWIO3AzhdFMvjnCLw55iqHrU98
	kZ2ZqSl1IPDARgcyp21f4s4V+7V7pVhE5FeRM4yjliFn9Fa1RlZQwuZE5sw8C1oFds1Ha9EfEi9
	U6YoBVX2k1LcqSN9pIg557daKtXfDiMaLwuUhmES3H/rPxVLMXLUOj4QgIHk0epSx8C+YTab5g=
	=
X-Received: by 2002:a05:6214:da6:b0:6e1:715f:cdf5 with SMTP id 6a1803df08f44-6e8ff7c8320mr21742836d6.15.1741301685267;
        Thu, 06 Mar 2025 14:54:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvjp20tEDMblS/SX0z+fmGjibqY6SKFgG687G6r4tW6uVdNve7F0FARHWp0aDZcMETKqdTzw==
X-Received: by 2002:a05:6214:da6:b0:6e1:715f:cdf5 with SMTP id 6a1803df08f44-6e8ff7c8320mr21742576d6.15.1741301684937;
        Thu, 06 Mar 2025 14:54:44 -0800 (PST)
Received: from [192.168.1.61] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8f707c721sm12227996d6.21.2025.03.06.14.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 14:54:44 -0800 (PST)
Message-ID: <c291e9ea-2e66-e9f5-216d-f27e01382bfe@redhat.com>
Date: Thu, 6 Mar 2025 17:54:41 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Petr Mladek <pmladek@suse.com>
Cc: Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>
References: <20250115082431.5550-1-pmladek@suse.com>
 <20250115082431.5550-19-pmladek@suse.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v1 18/19] Documentation/livepatch: Update documentation
 for state, callbacks, and shadow variables
In-Reply-To: <20250115082431.5550-19-pmladek@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/25 03:24, Petr Mladek wrote:
> This commit updates the livepatch documentation to reflect recent changes
> in the behavior of states, callbacks, and shadow variables.
> 
> Key changes include:
> 
> - Per-state callbacks replace per-object callbacks, invoked only when a
>   livepatch introduces or removes a state.
> - Shadow variable lifetime is now tied to the corresponding livepatch
>   state lifetime.
> - The "version" field in `struct klp_state` has been replaced with the
>   "block_disable" flag for improved compatibility handling.
> - The "data" field has been removed from `struct klp_state`; shadow
>   variables are now the recommended way to store state-related data.
> 
> This update ensures the documentation accurately describes the current
> livepatch functionality.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Hi Petr, I'm finally getting around to looking through these patches.
I've made it as far as the selftest cleanups, then skipped ahead to the
Documentation here.  Before diving into code review, I just wanted to
clarify some things for my own understanding.  Please correct anything
below that is incorrect.  IMHO it is easy to step off the intended path
here :D

The original livepatch system states operated with a numeric .version
field.  New livepatches could only be loaded if providing a new set of
states, or an equal-or-better version of states already loaded by
existing livepatches.

With that in mind, a livepatch state could be thought of as an
indication of "a context needing special handling in a (versioned) way".
 Livepatches claiming to deal with a particular state, needed to do so
with its latest or current versioning.  A livepatch without a particular
state was not bound to any restriction on that state, so nothing
prevented subsequent atomic replace patches from blowing away existing
states (those patches cleaned up their states on their disabling), or
subsequent non-atomic replace patches from adding to the collective
livepatch state.


This patchset does away with .version and adds .block_disable.  This is
very different from versioning as prevents the associated state from
ever going away.  In an atomic-replace series of livepatches, this means
once a state is introduced, all following patches must contain that
state.  In non-atomic-replace series, there is no restriction on
subsequent patches, but the original patch introducing the state cannot
ever be disabled/unloaded.  (I'm not going to consider future hybrid
mixed atomic/not use cases as my brain is already full.)

Finally, the patchset adds .is_shadow and .callbacks.  A short sequence
of livepatches may look like:

  klp_patch A               |  klp_patch B
    .states[x]              |    .states[y]
      .id            = 42   |      .id            = 42
      .callbacks            |      .callbacks
      .block_disable        |      .block_disable
      .is_shadow            |      .is_shadow

is there any harm or confusion if the two patches' state 42 contained
disparate .callbacks, .block_disable, or .is_shadow contents?

I /think/ this is allowed by the patchset (though I haven't gotten too
deep in my understanding), but I feel that I'm starting to stretch my
intuitive understanding of these livepatching states.  Applying them to
a series of atomic-replace livepatches is fairly straightforward.  But
then for a non-atomic-replace series, it starts getting weird as
multiple callback sets will exist in multiple patches.

In a perfect world, we could describe livepatching states absent
callbacks and shadow variables.  The documentation is a bit circular as
one needs to understand them before fully grasping the purpose of the
states.  But to use them, you will first need to understand how to set
them up in the states. :)  Maybe there is no better way, but first I
need to correct my understanding.

Thanks,

-- 
Joe


