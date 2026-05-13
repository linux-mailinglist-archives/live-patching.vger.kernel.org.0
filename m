Return-Path: <live-patching+bounces-2807-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0IutHlS1BGplNQIAu9opvQ
	(envelope-from <live-patching+bounces-2807-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 19:31:00 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1C353811D
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 19:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 53A8930975AE
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 17:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2F43ADB8F;
	Wed, 13 May 2026 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dm+VafH8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8634DBD69
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778692686; cv=none; b=BI6lLZhclO1Pms2xYioiVvPtUo5FMvxRgcm3urpP0tjvUTBoYMT/2twUml5a0n8L1ryy6NEVxDsK0wXuT1sQ+JCYuJ5Jy0w5g+w8+VssFRVL8yfYD2JkQtfWAdk2PCWBOVVSB9tPLHuqYiHDdJl29oqwmsyJW/Qh871yVvhiqWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778692686; c=relaxed/simple;
	bh=0m+5THNAPPxMlfnjeMAmEw1mWOPWOjMLssIwXrLZPKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f+rzgWVYAvvmu5UFTUaPMyf3Vu4475WcF9T4Hn2YH2csIqwXIffwGchXFmVfhmtbCIHXGmMTByn8EAzMN3Kd1QRyODWC2jpPmniuRxaSv0Zbd3L3Ac+7Rgz7fVJSt9aI4/ZZz3sKKqHRCYPrZyiTh7ZHiqUNlR2RSKl5zrE6YS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dm+VafH8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A2FC2BCC6
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 17:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778692685;
	bh=0m+5THNAPPxMlfnjeMAmEw1mWOPWOjMLssIwXrLZPKQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Dm+VafH8y6eASAmd+s561KklMwScvCuuo8sgjFrqF7M4aTBnZk+ULIr7sHmj8ek7v
	 Ll7PPMl7BJjd8cohEr1IlUEw6e5mmPFC2T+PnwEYlpqMx6BSnMCVPAMpVx5qBTMNYA
	 olV5lp0FFmPvWKNHAtuDlukqWAPCS813omqEh2IjH9itYQtuINph11N6M0kd1WJkwx
	 KZ8I6toNkByKhOgmH7tyBxxXYU0lIBDmwXFQQZWrGVX1xX7bMJA4Kles7Pgsa7rXVR
	 nNH7pxhl462J0Cou/k96GSJhdUO2sCdk5dwvMALpgN11z0R28g7IwNmH/7zFUqbkNS
	 Zt7dJ4SgE5n+A==
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1330d6bb78dso3730110c88.1
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 10:18:05 -0700 (PDT)
X-Gm-Message-State: AOJu0YwZ+SlyjuSMgPHN4V8J3JR1cbIooNyx5bv05k2/dfyupiYZqreI
	wh3Cs54zKW2mP58YwJ7v5tpWJZBSykyHLopxfolzoakJ07TcAu7xUG9afl9Hjp7b5sVv/z/11jt
	tF5Px/4AUTn4xnc5o10o3ZaYqQbEiLRo=
X-Received: by 2002:a05:7022:3d84:b0:133:14f6:621e with SMTP id
 a92af1059eb24-13428b911d1mr2771179c88.0.1778692684304; Wed, 13 May 2026
 10:18:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <agSjM8dxgnV9QQaf@redhat.com>
In-Reply-To: <agSjM8dxgnV9QQaf@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 13 May 2026 10:17:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6CgBtEGAK+E0n7+tnLAWNPTEuvnAo0vtQsbMVBb6htFw@mail.gmail.com>
X-Gm-Features: AVHnY4IMb-GLgDhziJLQyOG0nVA3PtDwZ6KBryxv6PRdoEMp72tupfH28-V2EyY
Message-ID: <CAPhsuW6CgBtEGAK+E0n7+tnLAWNPTEuvnAo0vtQsbMVBb6htFw@mail.gmail.com>
Subject: Re: Sashiko patch review for live-patching?
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7D1C353811D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_QUESTION(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2807-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,sashiko.dev:url]
X-Rspamd-Action: no action

Hi Joe,

On Wed, May 13, 2026 at 9:13=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> Hello live-patching maintainers,
>
> I've noticed several references to the Sashiko (https://sashiko.dev/)
> kernel review bot on this list and was wondering if there is interest in
> adding live-patching to the mailing lists Sashiko tracks.

I think it is a great idea. AFAICT, these bots add a lot of values in the
code reviews.

> Integration appears straightforward: we can submit an MR to add our
> entry to sashiko-k8s.yaml and customize the bot's email behavior in
> email_policy.toml.
>
> Full Sashiko Maintainer documentation is available here:
> https://github.com/sashiko-dev/sashiko/blob/main/MAINTAINERS_GUIDE.md
>
> Personally, I would vote to set reply_to_author.  I don't have a strong
> opinion on the other custom options, provided that the CC list is opt-in
> rather than simply mirrored from the MAINTAINERS::LIVE PATCHING file.
> Either way, I've found the Sashiko web interface very helpful in patch
> review.

Given the relatively low volume of patches to the livepatch mail list, I
think we can use reply_all. But if folks prefer reply_to_author instead,
we sure can use the cc list.

Thanks,
Song

