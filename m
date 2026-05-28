Return-Path: <live-patching+bounces-2918-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJ8mJBArGGrneggAu9opvQ
	(envelope-from <live-patching+bounces-2918-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 13:46:24 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 257E85F17C1
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 13:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6061303C001
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 11:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6F83E4C76;
	Thu, 28 May 2026 11:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I7IZwJ8J"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D028F3E3DA6
	for <live-patching@vger.kernel.org>; Thu, 28 May 2026 11:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779968321; cv=none; b=r+xpUggyxFWDIF8Qoz5AKYI/1yrXxafhDFkAmrZd+c1va3e501BvtXAf5yLY8SNuPIxk4EWtfvlRkVKKmQA3NMqaGoIRyVlecWr0Fy5R81Bb2ylpEi8R+yiwZl4qkau5ZUSCpTGSbw4vuMWF3aF8tqKTZVsT1nOF6LExk8hAxIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779968321; c=relaxed/simple;
	bh=8SGhWui548Ba99aC04WiP1c0zgeXquukggh5KrEpsO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jyXpQDry4I4V4RHHTRniQX5qvou7O82WzQsZTitcdY6rIoFmjm/WGs62Cpfa7YVmcVkeeYJnOmUpF8X2V+0iXDY/l85sT+UxskhWbqkwGZze8eB5Oi+8JN51YcjRSSl1kZ8SBcpGddjmMxY65mzVjW9Ktab3VO554mbqC+yqElQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I7IZwJ8J; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48d146705b4so134243895e9.3
        for <live-patching@vger.kernel.org>; Thu, 28 May 2026 04:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779968318; x=1780573118; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6iVKaZFS4nKqR7/9di1Ry0iAB7LixT3fLx6eL1lYRgc=;
        b=I7IZwJ8JqrzE9eh3Rf0W3/pvwd7nkWC0Pk6pPieLDoya0v72CYiTpS7C5dd9D1/gLU
         CjvbWAzn2k2/3d/KGSI7u4GQU5PvaMXiCgS6IO/75GQXRdJlOuqgWrKcJ7JJeWMpZ2Vt
         DdBKm5kLrpyVh3HpStuEHBilU1ehctOnuCF7G//wnLCczyVA30lzsXM7Qe6U/WpzvnXs
         R/grAYDPfoZicVasS1EJV988VbnwzJ4mb0xR9ltX8yIsSPRCZsCK7gYBz+CMXaR2dyNq
         gXGDqOmSaT1yr0Xao7FzWwj8nK1ApD4PJc2fsGPJI2U2pV//EI9LPiAh42SK6ftCtqRA
         q9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779968318; x=1780573118;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6iVKaZFS4nKqR7/9di1Ry0iAB7LixT3fLx6eL1lYRgc=;
        b=gXHgtVxygZZld2bFmqNpHbUmN5TXuRZKAE4OcJN1bHP5Q918vsthIpXPhiapnVkAt+
         OgkQ5ems+dFo/ZqSrJ9BU/8WSsC+2401knweq9cgbiADRpob5+h0VXIxnSsoJa8UksY/
         js42IJvKrLgzHeXbk7LvHf4wAijs++H66p0AvsYbhNZTVnhyfHG2HJs8rWUas1YMT742
         /X1B43YXNX9MIeduBNsqohjVl/XRjCu70YiaKNL5UaZZPZG6PaGp3LrqbND5bSz3PI9O
         p3VRNMGm2r+Ow74CYvjylQNlB+JJe1gP+ntU8nvicPWsrdh+WxiJdBn8hCKxgvCRmsbH
         RFyw==
X-Forwarded-Encrypted: i=1; AFNElJ+EQlt7+wP4/sNOvPBXR8Hp/V3vB5Geib4hxKrwcKkZgWEaB/MNk3jiK8A1tp4tqFAsYPZMzyXYmBWfSzW/@vger.kernel.org
X-Gm-Message-State: AOJu0Ywal4xl+G4dEFlA+OK8B/C9+lLTZnh1fvFbmim1sr1xJG1A13Wc
	KTOUi4IAEQeLRM6ZjtYzO7sLWqLyv3HSsExYEI9jDIeW3qKkDXiDWlCQ1jSr7TcEsM0=
X-Gm-Gg: Acq92OHJOeBzzfQxi+gP+kjSdyYWBwT99NVV5uUpL8Eq6/rMPtYx6dJCrM89gj4t0/Y
	Kl2GZmvWVWCIDl6wQmjpCheIZ+hjgaTwX8CKFspBACmTjFNlxGAH0QKY1HAbSfGbMIrttT+3ist
	DImQJ0mFsLpFSmfZrxlfcs3BOYL2+5rr+dzmseqEA8yIkkSBK2OdY8OPZc8m9TCEV5uObNu2IMa
	02mHl3dEcbjgCphV/3It3sKyU+nxqxaFKLg8a35WpdqHaBh64CQI1xMKvkKFN2hOvRo/tlhVgRJ
	DnuZwvwgPb+j6byEhNMLa9Nx6+eOXQRMjEhoge8fVfhpm12xY3U0T51jfHqLzeoQi5HcPo7NrwY
	WvcYc0YJ9hCFLDelI3s6tm63k85eUo3e+GHHPlh005oACEX41Wm7GzL1AOg9trODu/NJpKsaLPs
	CeSIRv6siO2K3bknJsZd3OZEOFCA==
X-Received: by 2002:a05:600c:1393:b0:490:3890:605b with SMTP id 5b1f17b1804b1-490428e0bf3mr440414935e9.31.1779968318318;
        Thu, 28 May 2026 04:38:38 -0700 (PDT)
Received: from pathway ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4908b7a70b9sm15593635e9.12.2026.05.28.04.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 04:38:37 -0700 (PDT)
Date: Thu, 28 May 2026 13:38:35 +0200
From: Petr Mladek <pmladek@suse.com>
To: Qiang Ma <maqianga@uniontech.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: livepatch: set LC_ALL=C to fix
 locale-dependent test failure
Message-ID: <ahgpO1vi4kj1WQqn@pathway>
References: <20260527095929.1504032-1-maqianga@uniontech.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260527095929.1504032-1-maqianga@uniontech.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2918-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,uniontech.com:email,test-ftrace.sh:url,suse.com:email,suse.com:dkim]
X-Rspamd-Queue-Id: 257E85F17C1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 2026-05-27 17:59:29, Qiang Ma wrote:
> When executing the command
> "make -C tools/testing/selftests TARGETS=livepatch run_tests",
> the following error message was reported.
> 
> TEST: livepatch interaction with ftrace_enabled sysctl ... not ok
> ...
> livepatch: sysctlo
> : setting key "kernel.ftrace_enabled": Device or resource busy
> livepatch: sysctl: setting key "kernel.ftrace_enabled": 设备或资源忙
> ...
> ERROR: livepatch kselftest(s) failed
> not ok 5 selftests: livepatch: test-ftrace.sh # exit=1
> 
> To fix it, set LC_ALL=C.
> 
> Signed-off-by: Qiang Ma <maqianga@uniontech.com>

It looks good to me and I think that this is a rather standard thing
to do.

Acked-by: Petr Mladek <pmladek@suse.com>

I am going to give it few more days for a potential feedback.
I'll push it then unless anyone speak against.

Best Regards,
Petr

