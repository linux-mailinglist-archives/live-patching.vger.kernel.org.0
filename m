Return-Path: <live-patching+bounces-2541-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBl5CLrp62nhSwAAu9opvQ
	(envelope-from <live-patching+bounces-2541-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:07:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAC8463ACB
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 416173009F8A
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9676834F241;
	Fri, 24 Apr 2026 22:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tX4YWBLY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73764312819
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777068471; cv=none; b=MzJTG0Wj2Vf1YEaLZNjdtMW06t3XSjv3S1+s9J++1mpB4Mj8txUYOSc3lltjo2JS3KlHSujW1Zt0K/I5I/OZdhLwxac7cTI4/Fi8yd74VqjbhjKD9eVVNRsKJZ3zJq0TLQdabtg0hFjs2L+uW3xm3AADE9CUz7UZPYaTbNj76Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777068471; c=relaxed/simple;
	bh=DM+r99HatCYe7H0txdhONnQvb1QjWU2MkLHs53DypyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VuKJzRVnj2ivcCpatsDfenhV+ozuxIpWqjHIN8KnJ12VrRq3jYFrQoDPLPfgw52xTMFIzChVLiBF2AITcevkWmhQKKUNwifzhDxN6F0mR5ruBEICjUWL3MED7vFxo79WaGa1HnZ1I249mKT8sE9EUjdHd79LSoMTwT6wJi57lIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tX4YWBLY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE40C19425
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777068471;
	bh=DM+r99HatCYe7H0txdhONnQvb1QjWU2MkLHs53DypyM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tX4YWBLYXIFd5a950WBsmuySu7Sp4A49jidBJzzHfB7J54bXScHwOXMSbfUBjlUjE
	 XFeRiHHr9DVethcPcGQlhroRTtvJdG50875oFC7xkgKsKVF5OtMRi+73yfDq4enV5B
	 X4x6npvSbljBPZ7tv/qxjMPNTBbZRo3FPdURHUVfC/krB0VElMxDFT+pwZetELweAK
	 YcuxFFWayDYItuF3OuRbQ26wGJ+mMXD9QOaPS/LiPiqyOs2qYEx/WMuDnjHefYfype
	 1r6flrs3LW/ZxvH55ZVSCsRLMKczn6s6e7xhSHLSrZEY6W942APR/KYcEt81H1okWF
	 wKJ5nl3KZWSTQ==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8acb856a674so99850506d6.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 15:07:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+sEACpuXoKhYkQMlaqHczQAEOvPb3HlrnCw+6EzogPpaO2o+WzzFEs9nzyxHdbr5oErjkQwn+3zoaJ5u4s@vger.kernel.org
X-Gm-Message-State: AOJu0YwVNqJe2MxFOMrU6WUCPKKTqS/b0Q7mbNXg1IsPrkdOs8KVgNRo
	YF73Q+UTzBkDkyl6RP3DI7m6vMyUbaQVqGvC18YCrm7POlm5plCaLh3VsWb29MQohRD5mXMEN1V
	bLJYA+pM9+ArU3EU6y2xrX+PwM5tV1wI=
X-Received: by 2002:a05:6214:2a49:b0:89c:47aa:1883 with SMTP id
 6a1803df08f44-8b02833c19cmr446783916d6.8.1777068470566; Fri, 24 Apr 2026
 15:07:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <f86bf0b781101152b35437bfe0e6a286f3955247.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <f86bf0b781101152b35437bfe0e6a286f3955247.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 15:07:39 -0700
X-Gmail-Original-Message-ID: <CAPhsuW40sLiVRA4FVFGX8BnyQotxFDYcGm2FLpbck=0Soh+Qmw@mail.gmail.com>
X-Gm-Features: AQROBzDhBzyIQn9r0pcneMuw036U-eC3saDglXOt2Ab9yOn7QaJ_DS_sS6FRwiE
Message-ID: <CAPhsuW40sLiVRA4FVFGX8BnyQotxFDYcGm2FLpbck=0Soh+Qmw@mail.gmail.com>
Subject: Re: [PATCH 20/48] klp-build: Don't use errexit
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7FAC8463ACB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2541-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> The errtrace option (combined with the ERR trap) already serves the same
> function (and more) as errexit, so errexit is redundant.  And it has
> more pitfalls.  Remove it.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

