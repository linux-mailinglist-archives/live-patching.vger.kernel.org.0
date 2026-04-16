Return-Path: <live-patching+bounces-2358-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8DGgENgq4GlEdAAAu9opvQ
	(envelope-from <live-patching+bounces-2358-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 02:18:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 99694409307
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 02:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C9833033F98
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 00:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADACC12F585;
	Thu, 16 Apr 2026 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lz50YU3E"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACFA3597B
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298706; cv=none; b=Z8gEfM2Lr1k4Do7g1/HaqVVJrre85b17qDzyonFCYXHAw6NeEMsjKXWDPZNvDryIS7AeCcUkhXV02WJsglNHgUmJxcXTZijiu5odNjej+R2lnvFyHibTMkHpIPBAx7sKcz6OPJ0kVU6CFIgID1Q728DU7LCLbiu59LpBnH/ydbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298706; c=relaxed/simple;
	bh=s15+HlWsVZfSmm6s6Y/yJbVZ85uiLm8rgnT5ySxwTyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ly9a9kJm8tpPbYnxPB9zgyA5ORv3hoKiBqWN1O9b7KQ0PJVE/B4OQR1oYTma+5MxrDZMOl9d3w/G+MbdM5n/vZlF0nWwYQHlQnFTC53XD7vp2l5n+V6+ZHL4l+AGE/s3iHhDPd5vJEatpjpKB+reJLtMQqWqytXbDMBz4Ge3vhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lz50YU3E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47132C2BCC4
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 00:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776298706;
	bh=s15+HlWsVZfSmm6s6Y/yJbVZ85uiLm8rgnT5ySxwTyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lz50YU3EdPVCuv/m1y/wKhZGUzDjq56Agb9tONBOOVgYjZA1kMT2D5zLoSoX84A21
	 Z4hgSA3VVY+684bGADBlrAktzaO8lM9WNKkhcuuAy84fV8OEZc8DaFZ5Hb0FRMBNUp
	 sWlDP+RCRhMwwTfUVSdxY843bUFE2vNMbzJZOOKcBtW49bxA7C9y/mXw9o+H4d8ISA
	 S11EezKvKwZBsl7YWkOTA3S8rP8Flj+3KQ8jVAfzpitREapAI0pm72fEVGGCl/b2kP
	 zX1E60qOSdi99INGnMwQsMNIVBJSN+5UJRWXGYGxoniPGdbmodONCnghaeu9OOtnJv
	 WoTZVE/H2n93A==
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d8e11b948so73828041cf.3
        for <live-patching@vger.kernel.org>; Wed, 15 Apr 2026 17:18:26 -0700 (PDT)
X-Gm-Message-State: AOJu0YyudogYxWEm02pwHAsKRXwdDF3gp1d2cDv0+TZ8MOP7gqvmsoJC
	tCgA9+ARKgn/z9KBoIlHbtI+VrIPLsFu8o2plmvB4UpjGErkyj/4P10GKFYM2B1UmNhf0VT6PNS
	5mR2HoGwdpue2crEJeDSFhwt8ItxvG2Q=
X-Received: by 2002:a05:6214:daa:b0:89c:ac1f:8d86 with SMTP id
 6a1803df08f44-8ac860f3254mr389066066d6.19.1776298705385; Wed, 15 Apr 2026
 17:18:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416001628.2062468-1-song@kernel.org>
In-Reply-To: <20260416001628.2062468-1-song@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 15 Apr 2026 17:18:14 -0700
X-Gmail-Original-Message-ID: <CAPhsuW43ny+kQN9FHiFe5ms=T78zhaT_Ppk8YZVSHKBEdS7d-g@mail.gmail.com>
X-Gm-Features: AQROBzDP7gUnA9Dqvf_neG1Vg7AwnGOy_wrnmcU_R0qAIf3iIkqHBgt-UkW2lLo
Message-ID: <CAPhsuW43ny+kQN9FHiFe5ms=T78zhaT_Ppk8YZVSHKBEdS7d-g@mail.gmail.com>
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
To: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, laoar.shao@gmail.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2358-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,gmail.com,meta.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 99694409307
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 15, 2026 at 5:16=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> Add a sample module that demonstrates how BPF struct_ops can work
> together with kernel livepatch. The module livepatches
> cmdline_proc_show() and delegates the output to a BPF struct_ops
> callback. When no BPF program is attached, a fallback message is
> shown; when a BPF struct_ops program is attached, it controls the
> /proc/cmdline output via the bpf_klp_seq_write kfunc.
>
> This builds on the existing livepatch-sample.c pattern but shows how
> livepatch and BPF struct_ops can be combined to make livepatched
> behavior programmable from userspace.
>
> The module is built when both CONFIG_SAMPLE_LIVEPATCH and
> CONFIG_BPF_JIT are enabled.
>
> Signed-off-by: Song Liu <song@kernel.org>

Forgot to add

Assisted-by: Claude:claude-opus-4-6

