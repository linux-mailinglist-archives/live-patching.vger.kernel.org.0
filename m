Return-Path: <live-patching+bounces-2542-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GOYmCDTq62nhSwAAu9opvQ
	(envelope-from <live-patching+bounces-2542-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:09:56 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E9B7463AE9
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00E24300CC2B
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01DC8389460;
	Fri, 24 Apr 2026 22:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjPQhCzv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F8C38759C
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777068542; cv=none; b=U/cTLdd/a+ZaU3NtAfzQEo35Jg7a/AJFQCN+oxcA/6Nwks+Khd3oky2uL+TSK9gE2TDnOR8HOiVqtDB3tZ5bQ+KgS2EC8ElQIB+y3WRZdIPRCb0e2YJG3+K52mN+nfhfoFgbN3LRj544BuWlQLZ4Gt4mrZ+HK4/h8DKr8407gjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777068542; c=relaxed/simple;
	bh=3sSuRSiE/gPB/7CQLXZz4KiHBEIIOM+2X5I3iVlViok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ExPlmoH9nWE+OQcSiCbah4N0NUeko1Ex0DEMhUUcWQlVyWlu6RQkrb6vAUY9Mibjh+xd/gJinpeA2juNuY2XWJrV8Wl5g3/TZJEec+eVzPdAY+5CAb/LXvJBflqv76CH33XhIJBH3WqHMTG3xGRXglxe1V7+pCgYMjBWMsIXnEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjPQhCzv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F455C19425
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777068542;
	bh=3sSuRSiE/gPB/7CQLXZz4KiHBEIIOM+2X5I3iVlViok=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BjPQhCzvAdRUksoFZWiufaeFJVK7gKBnqSYHG/NQjrkBFkcQo4w4ft7IMh/916NZp
	 8/dmxCqCwLQOn0vcJXvVBOlopDneAa/Br0igK4N1AyLna33wf94yOeM4tSpnKnY/6D
	 9mCPzz4XKW0RoO/BXYIyxo3lLWu3R9wcrRSTlq2bAe0ZP0mc83KFUf5crgeub9bzpL
	 4B9GHX4uIG8k+dHUApSO55qjy0oBu4GGyTUZsh/L7O2Q0p431o4IrCB6JYiYhUO/CJ
	 1aArDMh/cXAX4e3OIf4ma0m/z8ir3S/8n+F94VgoMHPbqzsbCtyzKLQZyBC4oLIxTS
	 Ln5X9/H4Ov8OQ==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89fc4147f2eso91929906d6.3
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 15:09:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/7fNGWQURqRmwHkVgMXDslQigy/dPWTv1IvD4Gcz7gzQ9rfPOxy+UDRbWbVaz3zopltKy3uuAPfW4dhErm@vger.kernel.org
X-Gm-Message-State: AOJu0YwER4t14K6wDIez9cVcKOGXl8awtpHljLw376N4Wft3Ys7nyNvH
	OjzPd+E9tQDIRnZPdN+0bDx/jB99eAdsjilxzHtKAKIbZjhJC1+1k8TZCzZ0jEzIfHcLqDQsMWl
	8pBiax+OqK1TAyW9Xsca/C7/YXg3kV0M=
X-Received: by 2002:a05:6214:498f:b0:8ac:73e8:af42 with SMTP id
 6a1803df08f44-8b027ffbce3mr531623026d6.4.1777068541659; Fri, 24 Apr 2026
 15:09:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <199a3d975e8e562421edd342b9eda242b4f57a71.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <199a3d975e8e562421edd342b9eda242b4f57a71.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 15:08:50 -0700
X-Gmail-Original-Message-ID: <CAPhsuW64h7DpkRZrY-6xCuxgJAz5yM3dNF2ZvhY5b-ckZF+-EQ@mail.gmail.com>
X-Gm-Features: AQROBzAnIgIFNZWU7eWDW-C-tsDmCnS55mcb-JsqSZ1YMskVuCWzpzGVMnEFXWU
Message-ID: <CAPhsuW64h7DpkRZrY-6xCuxgJAz5yM3dNF2ZvhY5b-ckZF+-EQ@mail.gmail.com>
Subject: Re: [PATCH 28/48] objtool/klp: Create empty checksum sections for
 function-less object files
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6E9B7463AE9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2542-lists,live-patching=lfdr.de];
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
> If an object file has no functions, objtool has nothing to checksum, so
> it doesn't create the .discard.sym_checksum symbol.
>
> Then when 'objtool klp diff' reads symbol checksums, it errors out due
> to the missing .discard.sym_checksum section.
>
> Instead, just create an empty checksum section to signal to
> read_sym_checksums() that the file has been processed.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

