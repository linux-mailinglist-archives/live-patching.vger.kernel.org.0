Return-Path: <live-patching+bounces-2265-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cD5lN2OFxmlALQUAu9opvQ
	(envelope-from <live-patching+bounces-2265-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 14:25:55 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6272A345287
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 14:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EACF2301C89A
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 13:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD773093B8;
	Fri, 27 Mar 2026 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M2ab4atr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BC321FF4D
	for <live-patching@vger.kernel.org>; Fri, 27 Mar 2026 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774617853; cv=none; b=J8jOxALp+sd2qh4hElKCHpGtekSG+teKNO4xkJhGZe4e+ShRU1ND+rnYDVQ3N39eqYETzUJNUpSLaGH9hnLG9aiZheRl4iXSmo5ragPdk8YuOs5u2dtYtIV3ILjOQ1WYjhg7xyHsnd7+arB6EPIsioq/BjuEXhlCxTVVHVGWvyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774617853; c=relaxed/simple;
	bh=ejXTOSKJ079hoJ09zoFLWAckjBH4CQ5r4z5w/ptDNg8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uge95mIO0JE27TLu8BDgUXvVUAg12n1lIV1Sj2L7PE7cMzYLXtXk4p2E74VNvP8CekrXGzT7d0HOgthiBqm8gkjm5JSVxW1Ni6z9zeCDe57Hc5DcwdxqWSvx8M8dSJk9q/aDhRbKLlVGD/fjFVkO86FOyD5mcebtTwppc+mErxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M2ab4atr; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48538c5956bso20256285e9.0
        for <live-patching@vger.kernel.org>; Fri, 27 Mar 2026 06:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774617851; x=1775222651; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6TxywXtHWHy04GPoczvW/ll5a4fKqL9h3PQIZK9hKE8=;
        b=M2ab4atrkhJnPVKZQm5tbkvLd0/8bz4Wq4qhdKxuo/HkUdHORElc+FIrvJu01vHzrk
         N1gG45aci2L1GONnKU+C8PwijofpunRWrGERq4PoAFhZ9XGDgzM3BiyvkyD+ThatXMFT
         9WifkhWwfTvZo+B+xreIzcnKh3bQZhJvt27W0B7XoxGclKeJSHg9P9wOEeOVIkFwApLM
         nRc53LUbuNImLGdAf3rnPlJRIEItxcXw5k2YtSIBCn7DuMcNDxnhHiSHXI5FqbOqVelb
         ujrKMiYxuXKIFfHNrEbU0tsED2lZA9XN18yXauUVdGsCHX+oCOSXzsDYP8s1nkngjQsl
         GUUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774617851; x=1775222651;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6TxywXtHWHy04GPoczvW/ll5a4fKqL9h3PQIZK9hKE8=;
        b=NINdFhGac5ni6aoqT0TuC0aftp+qhM7dfZfsa5fxcjd8yqZxWoN15LUXw6qOfBgpeo
         A95RyTk/ab6PfDSZz5e813lTTcwy4YIyuLvoxFl8Mg0nKQiZS/BOH7ATH+/wQfpFd+gt
         NnacWjlT8jHz7uxnR86gI7l0eD4HEpeQjWCF3/XSKaPdBZywdWyZ35p9y1SQAzyVccMX
         fBO0hKfkmF1ZxOIj0mfR6GjC2/zgre81uqCR6MLWI86FRGu+IACiqX+Ezv98qBvQmLUk
         +3op0rmor2FpnZz8kbW/bSUR8A4Gd06ylX5+6ltE9ut4HTCgg+VbE47gFHm5OVFYBn1I
         ZOyw==
X-Forwarded-Encrypted: i=1; AJvYcCX9SYLimkSaC/JMqW9j6m2TVPN5o/ZDTJxs0Jy6gixouKyVUZycqEspaIZ5SNZw9sDDOeVxQhnKqOIeWuWB@vger.kernel.org
X-Gm-Message-State: AOJu0YyR6f/FdQMGBlUcsrZfxA9KcPdDDi4B7VdFo1ZfuFmUdK60rlQK
	+8RgTjxiweg9gZ55cFgLjalgMcNtEmCex5rWrbOZqxgRM6uTnuXLUDUJ2/3vFLh2P3E=
X-Gm-Gg: ATEYQzx+tLl4i9W0TtRK8dMa64djsbTVbCQQ3iT2SYaXuSmL1hCzknjrHC0BByyornB
	QaNq0Vu/++9KEOBbKmTp3Jq0l1pJpVG+rydqVZmCKV+wehsJjn0vGecGcNR8DJZoOz7PWccpGZN
	qoKIOzixkQEbZwSrhtbV4AlR44c2zD53rboIQYc8ZpBAkSibBq3xTrvVGM4BfOGoQwtm0wVtqB6
	PU+f+ilPLW1K7zfhJRYPk4Zs3jDogoSmB2GZK0LWPJTgbXLz7IzkFqLxCdKNWLN0fIwMeeZRGRO
	XG4xPcuhKXJcbXlLLnk/LUY4v2Kb+8RWDYSr659+uPVwnWMtUVG1c3xdgJ0S16tyGwqr+rBiR+j
	5ri8/My/rXPx4LVvFgjaG2rFsp3O7diIFqxxlGquczU2z03WPnxZ6JRfkAwhaSmLTv2+TyGNjPG
	EossvIx/kELGBxi8mNSVXpow+E5rN/S0wsHDY+dqcOxfDo7yb/p7xh5kNE26y20b79FypPBQ==
X-Received: by 2002:a05:600c:46ce:b0:477:9890:9ab8 with SMTP id 5b1f17b1804b1-487290a929fmr33140695e9.3.1774617850566;
        Fri, 27 Mar 2026 06:24:10 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:c8ca:fb24:208a:b63f? ([2804:1bc4:224:7800:c8ca:fb24:208a:b63f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48725d2abb8sm18514315e9.0.2026.03.27.06.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 06:24:10 -0700 (PDT)
Message-ID: <9a72dbd0523254209a733ec9e89466e7f0dc3e00.camel@suse.com>
Subject: Re: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>,  Jiri Kosina <jikos@kernel.org>, Petr Mladek
 <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>, 
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Fri, 27 Mar 2026 10:24:05 -0300
In-Reply-To: <alpine.LSU.2.21.2603201136401.12616@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
	  <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com>
	  <abhjYtyveer4niGM@redhat.com>
	  <alpine.LSU.2.21.2603191349440.22987@pobox.suse.cz>
	 <0d85d8d7533a7a78d1f8fcc1fff8ffc73b1cf225.camel@suse.com>
	 <alpine.LSU.2.21.2603201136401.12616@pobox.suse.cz>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2265-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,dominikbrodowski.net:email]
X-Rspamd-Queue-Id: 6272A345287
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 2026-03-20 at 11:45 +0100, Miroslav Benes wrote:
> > > So I would perhaps prefer to stay with the logic that defines
> > > FN_PREFIX=20
> > > per architecture and has also #else branch for the rest. And more
> > > comments=20
> > > never hurt.
> >=20
> > Agreed.
>=20
> Hm, so I thought about a bit more and I very likely misunderstood the
> motivation behind the patch. I will speculate and correct me if I am=20
> wrong, please. The idea behind the whole patch set is to make the=20
> selftests run on older kernels which I think is something we should=20
> support. The issue is that old kernels (like mentioned 4.12) do not
> have=20
> syscall wrappers at all. getpid() syscall is just plain old
> sys_getpid=20
> there and not the current __x64_sys_getpid on x86. The patch fixes it
> by checking CONFIG_ARCH_HAS_SYSCALL_WRAPPER and defining FN_PREFIX=20
> accordingly.

Exactly. The definition was added on

  commit 1bd21c6c21e848996339508d3ffb106d505256a8
  Author: Dominik Brodowski <linux@dominikbrodowski.net>
  Date:   Thu Apr 5 11:53:01 2018 +0200
 =20
      syscalls/core: Introduce CONFIG_ARCH_HAS_SYSCALL_WRAPPER=3Dy

>=20
> So, if this is correct, I think it should be done differently. We
> should=20
> have something like syscall_wrapper.h which would define FN_PREFIX
> for=20
> the supported architectures and different kernel versions since the=20
> wrappers may have changed a couple of times during the history. In
> that=20
> case there could then be an #else branch which might just error out
> with=20
> the message to add proper syscall wrapper naming.

Well, it seems too much for a simple test to me, but I can do that, no
problem.

>=20
> The changelog then should explain it because it is not in fact tight
> to=20
> powerpc.

Makes sense, I'll change it.

>=20
> What do you think? Am I off again?

I agree with everything, but adding another header file seems a little
too much work for a simple test case, but it's doable. Let me work on
it.

>=20
> Miroslav

