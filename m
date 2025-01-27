Return-Path: <live-patching+bounces-1061-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA4BA1D563
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 12:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0897B18875B5
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 11:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83FD1FECBF;
	Mon, 27 Jan 2025 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LHX4Pa2z"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D35E1FDE20
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 11:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737977756; cv=none; b=hmW7CbnhVjQMjTHQ1dOjoi/KHWK3Vh/kYKzmVSFQ3SOayh3M/YYpH2pEwDPZdzBiLaGvVGHiLRAGSec1pb5wtIBbk3MNrTZwc5GxJL++Kqzw5UqswnsatTLVuRouMOYxlleetBM8UXKyB4k9mopQUZoTq82AYBQoMF84eMsWt0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737977756; c=relaxed/simple;
	bh=T8lXwYoK0x8G1t2lmU/P5kGh81LSYe5bQFAp3RP4o80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=adgf55uCO0htaOQVr0plVvYgxW+ASpu1a2IfXgYEJYZg4PrAer9+p10ZfDHQgbGd3spEDF+1vKYBrDHh89NM0zMQTGGmfnF4oYmmT3e3RFMUmNPzieHOFwX5nS+Xka9cgW5YpbxFrsSGFuU1AOFBlsn+uQTZmv//yb4LBTzCsrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LHX4Pa2z; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa6a92f863cso908590566b.1
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 03:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737977753; x=1738582553; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8zb5dDSWfAPbQtfcZhMyII0+GP9Q7wdaQN5r+kGdVO8=;
        b=LHX4Pa2zARDIKSi8hn+/q6AhFQ/zEEjz0glbxYfLCjw0+rkoz82V0RQDN9MdoiU4vX
         kC+O6XoarnhG2wTIsRYQ/viy8m2gtVNQGeeAFwsulxB7u8VbMEZwia2uzdfdXeK3pVjc
         Yn7tEu+pUCZtnHHvZSE6sjkYQkPChgxtNmVBbeHa8csM+ZwM+Ruk5ObgMj9JqeTePrkv
         LNz5j06PTbWqRJ5mLRGcOG9DSgdrqMkFgdTH4e+FpA5Hq303V2RlDuM4Sp4GO5JggeSM
         38T/Q0XNsfcqWgioj7BdMRYJs2+Uh4d7OJyrj6PcT0P5WdqwtwsHe3lt554SNX/AAKqu
         NeCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737977753; x=1738582553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zb5dDSWfAPbQtfcZhMyII0+GP9Q7wdaQN5r+kGdVO8=;
        b=VGQCUTUI3ExuBCTPRgjfSiPkXIEeQes8i1d8zgVTZS6xebfK3fkyC9eHe5eLqZTzzx
         IgUeA687JeqwYi+8N7AYLUDRncxB+9mMihXfwlDgDBBdvpoKXk5/NUuaXXjjG9EJFpJB
         jVVoQj7xZl/jXRkRny8PSihYaEJJj/y8QLZidYgFM4PPtpZIAawJ036MLfbPP1BC8LB6
         ImB576qOU1Ha41LsTRN4cnfPKepS7NvLbhR16jvrM1j/0GHIN6kjMUJpNgabdZY4bLrR
         VJQjg1LpHfL9f7NQPinkOSlGsaoNtzpTCCe138dos+pI6NNt5dPzNGkxpO5stMx2vfch
         7kXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSch436kNMkGzz0I6nPKMYMRrjLEzzEF5Z3bIe8sFJlosSdktyLEB7F6wQXCTe3wV28dCv6LSUgSmT8jLV@vger.kernel.org
X-Gm-Message-State: AOJu0YwsdXHPnrDOGsHJ3I0U71FIsj+QIk66HYkAdvDqZMzFx+a50cAE
	VbU+AJXfKMpCUfhKFAtWxPVdrdISgIrfJP0Febd8YX0rwYp74I39AoEhpVXHhcs=
X-Gm-Gg: ASbGncsknOyMnCHYAVAPNavjUP/Np1SYIUvCFYCq8rRU7F0IIWSfbx8DUSa2Ls4eOFt
	k/zCfOa1vtL+yoc6EFJ2UOvvywK2rkvEd17XJ9sZ6IRZTyNWSOXdRRMwC34JZqr21RoqzZiAEeX
	E3s5WfNA6jSmmqOuQlzIMtwJjh9PdTklbiEwsYc19rwMxMh6QJrdCNPuyPOVgY/KZOo2RE4VWSm
	QOutmZPRc1ds4r5St790mQ3aVXAvA5P+amYjgh1VoQrBSlUdqrU9WFA5y617+Miiv05LrkowoE7
	bkSoprk=
X-Google-Smtp-Source: AGHT+IES/sxEF+BZSWJQAk5rNdbZSsrSF6vi3KXJQiYSQuO9FLRRC5atvuAKwpmQ4GGZa33a2aw0kQ==
X-Received: by 2002:a17:907:60cc:b0:aab:c35e:509b with SMTP id a640c23a62f3a-ab38b4bb44bmr3667711566b.55.1737977752859;
        Mon, 27 Jan 2025 03:35:52 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6760fbd46sm574262766b.135.2025.01.27.03.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 03:35:52 -0800 (PST)
Date: Mon, 27 Jan 2025 12:35:50 +0100
From: Petr Mladek <pmladek@suse.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
	shuah@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, naveen@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] selftests: livepatch: handle PRINTK_CALLER in
 check_result()
Message-ID: <Z5dvluAy6miSNyw4@pathway.suse.cz>
References: <20250119163238.749847-1-maddy@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250119163238.749847-1-maddy@linux.ibm.com>

On Sun 2025-01-19 22:02:38, Madhavan Srinivasan wrote:
> Some arch configs (like ppc64) enable CONFIG_PRINTK_CALLER,
> which adds the caller id as part of the dmesg. With recent
> util-linux's update 467a5b3192f16 ('dmesg: add caller_id support')
> the standard "dmesg" has been enhanced to print PRINTK_CALLER fields.
> 
> Due to this, even though the expected vs observed are same,
> end testcase results are failed.
> 
>  -% insmod test_modules/test_klp_livepatch.ko
>  -livepatch: enabling patch 'test_klp_livepatch'
>  -livepatch: 'test_klp_livepatch': initializing patching transition
>  -livepatch: 'test_klp_livepatch': starting patching transition
>  -livepatch: 'test_klp_livepatch': completing patching transition
>  -livepatch: 'test_klp_livepatch': patching complete
>  -% echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
>  -livepatch: 'test_klp_livepatch': initializing unpatching transition
>  -livepatch: 'test_klp_livepatch': starting unpatching transition
>  -livepatch: 'test_klp_livepatch': completing unpatching transition
>  -livepatch: 'test_klp_livepatch': unpatching complete
>  -% rmmod test_klp_livepatch
>  +[   T3659] % insmod test_modules/test_klp_livepatch.ko
>  +[   T3682] livepatch: enabling patch 'test_klp_livepatch'
>  +[   T3682] livepatch: 'test_klp_livepatch': initializing patching transition
>  +[   T3682] livepatch: 'test_klp_livepatch': starting patching transition
>  +[    T826] livepatch: 'test_klp_livepatch': completing patching transition
>  +[    T826] livepatch: 'test_klp_livepatch': patching complete
>  +[   T3659] % echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
>  +[   T3659] livepatch: 'test_klp_livepatch': initializing unpatching transition
>  +[   T3659] livepatch: 'test_klp_livepatch': starting unpatching transition
>  +[    T789] livepatch: 'test_klp_livepatch': completing unpatching transition
>  +[    T789] livepatch: 'test_klp_livepatch': unpatching complete
>  +[   T3659] % rmmod test_klp_livepatch
> 
>   ERROR: livepatch kselftest(s) failed
>  not ok 1 selftests: livepatch: test-livepatch.sh # exit=1
> 
> Currently the check_result() handles the "[time]" removal from
> the dmesg. Enhance the check to also handle removal of "[Thread Id]"
> or "[CPU Id]".
> 
> Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>

JFYI, the patch has been committed into livepatch.git,
branch for-6.14/selftests-dmesg.

I am going to create a pull request for Linus' master by
the end of the week or next week.

Best Regards,
Petr

