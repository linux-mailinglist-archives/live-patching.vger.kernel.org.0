Return-Path: <live-patching+bounces-2932-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFlTMQpZGWqtvggAu9opvQ
	(envelope-from <live-patching+bounces-2932-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 11:14:50 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 303365FFC2B
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 11:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D98D53035F29
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 09:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57A53BBA1A;
	Fri, 29 May 2026 09:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gh4HcbkH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A613BBA04
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 09:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045910; cv=pass; b=upmFnO8i8FzEs+arWGo3vwAFTX+Pwy8eRYXITxgItWittvrmgP9C6lXZhE54X/r1/nNTqkDc3/hNddWcPvj77PkfrfIKAIWILxX/ehxtDDeR1evobCa6F1XJE1TPjn9DIN0Rsza8glyj8LtV04VNWSNbv7Aw9QBspMcjg1E/kDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045910; c=relaxed/simple;
	bh=CQeCxWPRmFsxaf0wskbw+Y2MvOe3sA3UOSGwrmYqRys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cjNU91js2yko3IuNWtDNdTzSVja86UcmNhoVIXbgxLXML8xiv0OmElNvcbC0Y/JWExztTAIbX+eifu8Pw4uGZwNB3BPDEs1zHTyI6SJOU0iAcToOjliNpUKurdsyLnOEN/XD8BpkInYLEGYcYVnMkT2BieEJAQHIl/EaL/lnEE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gh4HcbkH; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7cb345cb5bfso117096727b3.0
        for <live-patching@vger.kernel.org>; Fri, 29 May 2026 02:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780045909; cv=none;
        d=google.com; s=arc-20240605;
        b=IQsdGNVVXPUU3VtEAFfAUFvmiicIETV/uEc+uaNoAUoOP9VU6dvX2x9ptYFiZ2BZyq
         9UJ5jq3IcMY8ElXPPFCYMJ6+CBmqmFwDYBVnTpIe4ValNEdj3Gri8dbpfkaY17BvabJb
         HfRzVJDqMG53DmtQ6RjaKPOIip/fSIq5WNQ7X8ezeX8OOFP+/ccDhCYUqXwzUjBjHnjm
         67AQE/6Jn5X09qCXYP2WuIRIR55oR370LNS/Xn1rPaNLAvPlQdUziskGZqCwVAgX9o0y
         GLDXWnx5kMrS9nh/j1NTy7uBYlrRYh6IIpXeZFPFL9njZYfSZzZSQSke39NXg7Ykw/4l
         IoeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CQeCxWPRmFsxaf0wskbw+Y2MvOe3sA3UOSGwrmYqRys=;
        fh=zH75Ss1lNO6SQ0+RRWbZ5nu6m+rDbxVKUCt4yKQEUKA=;
        b=QWvJjRuodo1ViAiW4JUjiPJNuEnomzrNv92ytbC3/OAj/zjqyJrtrhGp9pTvIsACSM
         3qqjP05VHoHBMPIBclJclzB1Dq40Dsofh1BJ0VEI9ZoM8mMhvEP9iI+j03nWk82M6yhD
         ixkjdFg1zH8eUpLTJDexnggXtyYWx6AjSnRiYafLX86xj6XdrwBLrSAMriiJOUlNpt1j
         UV2wZpCf4QpEMuUwUhLA2ASE5XpNUs2WsWFdF9k3RU9VIPKiUblEvmHRIrcCd1SWjHhS
         WGdbht/ezQfu5635ndLLVPJIv5VQjkAR4rfP6PY6H41BWcyhPjKdxIn6sGWC8lMyk45F
         e4SQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780045909; x=1780650709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQeCxWPRmFsxaf0wskbw+Y2MvOe3sA3UOSGwrmYqRys=;
        b=Gh4HcbkHFXzPxfN1pahjrTfkpgELjGIwkHnpXHPrKem0hMDWyAyygP3D5bxJ7z9Aus
         /Ep+Da2Jm6JCx83QdxwzlRiw1zU218XgUeylhzq4QG1fJCcxMJPSejY58YgrmsftvAUg
         f4Vi9CPRomm3aovYRPJfd44Jma53bEkXCnfOh23U5rge2lsz9OXS/O2V29cAnZNZVuYV
         FaVzTOAszFNsiQ+7uRqDCMbUlXO95R9KW3yGhLm7yEa86wF6FzyBT1enRWvZoG28+fHo
         ERzg0kcnB9IAghhmdSd3qaNEmvgZeIAhxYMAMi4UeK0iBFLAWKXvn5ucTHsKG6DKjAX4
         zpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780045909; x=1780650709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CQeCxWPRmFsxaf0wskbw+Y2MvOe3sA3UOSGwrmYqRys=;
        b=hJPF1gqCdds/xVFc9KWg6LPcd+A3EyhJAzAWfCN0ZfylbxgOfHDePDU6FGxPgUVzo3
         9PLKjjwLd0TvxVkLbdEoxuZZG/OjCKGr8Ib2K7khagEF45euPNFTrZsIaSKhK0PUsgL3
         XtjpgpiXcWNyGeNcZs/7C6RLreWlZaKsz+DVzEWZsoCvxLyaAIxfGQ4psEZ+MoBH7hXc
         m7VEGNep2pNpEMA3/2B5iFaA5WY4U6DR2ddwMVMO0EafrutcRdoVvDBB4JNSqC+TEeV0
         Msv5qmTFP4IOmL+ZyoQkoypU3pweweNGNvST8hjn/OKOS98KT2CmbwCO00gnX8IetB9J
         7UHA==
X-Forwarded-Encrypted: i=1; AFNElJ8zBeVGpfIqK5XVNmbl4xXVoPMrnWHC6e0Lwf+0Li38FIsqm2n6v5tc9z0pHhKjGPC0JGHQ6gscz9YB0w7+@vger.kernel.org
X-Gm-Message-State: AOJu0YyVKjPFLo+P6CkoaUt8mxJSkXAEwyhq+h+6i2IH9jPE2wfZ3o72
	qVy/1Wtd94cJuC4VsprJWVqho52Zbq/3Fk0OPvMSInEKRhLV+xSTbFqwnUvE14x4cWoGo6/A6k3
	eCQ3g8v8uGWuIw8vdZEsia5vOxJa+1yA=
X-Gm-Gg: Acq92OFMGyRKHuyiVQov6+MVQh3dxPMGMg8ud403LFqSvYsfGwdFtkGuWvNVTAxXykf
	gtXl+PjGhcaNHzsinwnK/WiAT2FiV4AEzzoaYdX2D00EFAQjDt4dE9UL8JXW+yfhHJrT3kLJMQI
	4Y/KdeNg9AfKW+zkJQtaFZFLCaISRCMoGZTBr2QdPb3uM5BOkH+1qSQgzq+sspueE3OAM58q4/M
	Mpjdp0UCZ9imIFH5uD6sH7pevQ6mKUYg/MOtXsTsHSCWsv4Mf7KTBIVS/xmX4qQq2MyHtNk/QM7
	g6XtUOfDq2VYUJh40yty2KFXG64fhIJlx2t1ioxeg0ElSex68AsKG0lQj8wT
X-Received: by 2002:a05:690c:6b10:b0:7d0:1583:4cb7 with SMTP id
 00721157ae682-7de465efe10mr14565977b3.15.1780045908886; Fri, 29 May 2026
 02:11:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529034542.68766-3-laoar.shao@gmail.com> <20260529043212.1F2ED1F00893@smtp.kernel.org>
In-Reply-To: <20260529043212.1F2ED1F00893@smtp.kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 29 May 2026 17:11:12 +0800
X-Gm-Features: AVHnY4Kx8ICsYHlCfNys4HePTH5AEmq9LURZ7cbd0SG44HJxZd_BiP2F1Zp4Iz8
Message-ID: <CALOAHbCfZ84TYvc9rx3uHngZ+QO5+T4cUNOe3s1_f=UY3sDrdA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] livepatch: Support scoped atomic replace using replace_set
To: sashiko-reviews@lists.linux.dev
Cc: jikos@kernel.org, pmladek@suse.com, song@kernel.org, mbenes@suse.cz, 
	jpoimboe@kernel.org, joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2932-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 303365FFC2B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, May 29, 2026 at 12:32=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] A malformed livepatch module with a missing function `old_name` =
will cause a kernel panic during patch compatibility checking.

The same issue with Patch #1.

--=20
Regards
Yafang

