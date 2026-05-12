Return-Path: <live-patching+bounces-2750-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2GViGTy4A2rj9QEAu9opvQ
	(envelope-from <live-patching+bounces-2750-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 01:31:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EFC752B4DE
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 01:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 12B7E302438B
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 23:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBA53164C7;
	Tue, 12 May 2026 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RFwG7psz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988FA25B0BE
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778628661; cv=none; b=ezlZEGZtEXaiIVRpWzHhSklOhpmcH2kV3FmtBK2SvAErqj+zqHIZ/OGlrj8KD+VGVgf8PkfejMOmTRvsMpIdkPPvm0/tx+46wHn5xPXYSlrlR0TAUgoHszuw2u6SEiz9lsNFOzTUNXR3uQJ2oFM7r0pLLW5qhCuFnZ8ryuwVC2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778628661; c=relaxed/simple;
	bh=PWN9WjQeZL4CS/4El9jWxT1JcxI8SXHsZnSkEOumzvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pyAIRoHdzFoqfI6gFC9Em2ec2rM0+WtjI7KjtDV5HcCHr9Pnc7Ree+OEEmstGsyBB7IdPCxVAwhniq+/iQlZaf4dmHONwYiIMbrYBHgdWrKArLuOglisGqLAnduMb6bXAmRIpL+Kypr6lhDNXqdFUdcYap1aUmniC0RLSgZyU+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RFwG7psz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B5FC4AF0B
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 23:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778628661;
	bh=PWN9WjQeZL4CS/4El9jWxT1JcxI8SXHsZnSkEOumzvo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RFwG7pszK6/F+uH3b0xWw/H6IKv5kkYRaBfDZl+lIgXXr/Irt4z0YwLJfNIcLFWB8
	 gfAibShqPZdB4R94LMczDd/bSsoEOk4T8JOxDBMZUWP4gdMyL19ydDni7pU9QphAI9
	 kXTa4iYkw4SdHSzBOuyvgInbj/cWR2T3v4q/kaRBJO+iZ4DCCJ9U91Pjd+6nqzNdcY
	 ud4lFuza5v60vczTusHLkylM/WeTVfyepUvTw7PNbEKF0/07V1Vic+6A7juW5ykJlS
	 eesj/IeOr+Mo130dMGhvM3+bgd2uTMtwpfeSiZB8yqtm5EeQk/74o/2dnVT9zziWMn
	 3LIrF8BT/dL5g==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-651bf695701so6700824d50.2
        for <live-patching@vger.kernel.org>; Tue, 12 May 2026 16:31:01 -0700 (PDT)
X-Gm-Message-State: AOJu0YxyNF0fUnxX5BiL3XXKRYG446WpRwxwKqtoWOVw6lxBNaV2BKVJ
	nvXNM/cJzHCvEdmG+1sQ9A+Q48A14LYcAJr6uHpP9b+ywJcQv1/GTi3snVnJ2SY06ERfXQhE1GL
	oiTbfLXQq6WtjzL/J5q2aLl9TwwZBmOw=
X-Received: by 2002:a05:690e:480a:b0:65c:6164:f29a with SMTP id
 956f58d0204a3-65df6319231mr815659d50.46.1778628660547; Tue, 12 May 2026
 16:31:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512221102.2720763-1-joe.lawrence@redhat.com>
In-Reply-To: <20260512221102.2720763-1-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 12 May 2026 16:30:49 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6YGdh4xFcsfUiGtVzLg2nR_cEiQpvmyEN+Ffyf_O53LA@mail.gmail.com>
X-Gm-Features: AVHnY4K0Gfzdny_AK3Itks95571WEdlKM1aeyjNb4fcU-GF1M9WckymdT2XOs9I
Message-ID: <CAPhsuW6YGdh4xFcsfUiGtVzLg2nR_cEiQpvmyEN+Ffyf_O53LA@mail.gmail.com>
Subject: Re: [RFC 0/4] klp-build: simple OOT module support
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3EFC752B4DE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2750-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Action: no action

Hi Joe,

On Tue, May 12, 2026 at 3:11=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> This patchset introduces support for patching basic out-of-tree (OOT)
> modules.  The primary motivation is to streamline testing for objtool klp
> diff by providing a flexible and stable environment.

Thanks for this work!

I would like to add to the motivation here:

It is actually useful to livepatch OOT modules in production.
When using kpatch-build, we (Meta) generally do not patch OOT
modules. But there was one case where we had to do it, and it
required quite some manual work.

If we can make building livepatch for OOT easy, we are likely to
use it regularly in the future.

Thanks,
Song

[...]

