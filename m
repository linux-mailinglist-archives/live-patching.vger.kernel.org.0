Return-Path: <live-patching+bounces-1522-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1120DADF97F
	for <lists+live-patching@lfdr.de>; Thu, 19 Jun 2025 00:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C75A93BC724
	for <lists+live-patching@lfdr.de>; Wed, 18 Jun 2025 22:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FC427EFEE;
	Wed, 18 Jun 2025 22:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kVxxHkCq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004B627E05E
	for <live-patching@vger.kernel.org>; Wed, 18 Jun 2025 22:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750286301; cv=none; b=obfy5+K7qK8ckHYcQrWUoM0ekWqzPyADOrPaccnVBSndi6tDPC41X1ZKNwhA+8u/liLA/f8qWp/kTxri/kfIzrIPyBkdVWrMIwe05CauKwWeUNbMI1vVWjlZG1ZZmTF986dUKmIlfHC1IOCjWcVWds742A8it9nUwhOmH+M28QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750286301; c=relaxed/simple;
	bh=TIR41IOuSunvaJR25QNHhYWA22u3V9nnI7bWi22GJFM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ddDbiMpaELWNAiT1Pbvq9As6uBY7pRfmA9hkg9RVfziTyI3FgIwaRQj2GvOLpQMC3Gtrj0RVh5yzPpr2JqsaxsyJQuPruQ5Zo8Txy5FUkBOuC3AtHa8xZnwg7cphi3/Jr8n9UqbCnrkPf2NDKj41/63q/8Kr66eOhi4Zs7DwZrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kVxxHkCq; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-528ce9730cfso41189e0c.3
        for <live-patching@vger.kernel.org>; Wed, 18 Jun 2025 15:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750286299; x=1750891099; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsHGAv3KLKvTQx3+E9vEHRVCKTx/eVy+7jBAKLwsTFk=;
        b=kVxxHkCqXzO2khu3Ns4kF2I4i2pv1sww5VRDCwbPB9QOijZeTQI+af6tb2Mcw+fidd
         2OXMcaK6VBz3q5EFEG5r1g/c0tOtKQDjSv8hTX1GkQDoRKv/9Gc+Ozic8WqKiZw2t0oR
         CoWQ9vRg4TBKFySxXJtNMfXKQBu9BZi61pDBznlsEhNIfLGThLQLrZJc9RW5UnFoXulw
         lPaYxoYyKy/JkPvk50kn/nZYb37fKBcFBnrFXiOX7P2f8/oXaDzwrSb1hMxDuRRJERY2
         3JUBcszP8qWv6x6117BM1dNaNhnM0uSH1tmrqwFZcVbHZwSdFeNJnhE2jm6REGC3iB2w
         s8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750286299; x=1750891099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsHGAv3KLKvTQx3+E9vEHRVCKTx/eVy+7jBAKLwsTFk=;
        b=k7WbDk21vIv1CHk1aCYgXZcOQUM9WXUJfvsv5xIiGA2Fvu3jzOku0WVa1tzQSSBDTo
         mkNgnxm7+2Vw1FeAsmC75GAWwWu9X3WFinW8V+FZ8aR6Ptgd4CP7JnPTvQHVPLKorEG+
         2F0Hj88JpWez2ZVEoxV4cXVe5l4v0Ry7ia3j90CQMDqh5chuBjXb0o5FQ+Tcwm+NRw3P
         G8nVGrQv4vzEX50J9MnwDx9vo9wWSSf8j9VSAFsCjV+yAeOt2rqTtJSZ8dNu0wk/WLpt
         6Q/mtoXe5C7/iCprxn1Wuc4d0mqITQvZ9Z7N+cryiAbonsRCyiDU6SYX8mqTZUT4N6Hz
         tERg==
X-Forwarded-Encrypted: i=1; AJvYcCVO00gg8MlpH3twPeAq4f/oJcJ20joamWjU7w4Pe0RbnJz5WQvxhwP+T5Jxn/bhF55+LptK7d+gaW3tUZhV@vger.kernel.org
X-Gm-Message-State: AOJu0YzWgvkzHigIWLb4oHsr1A8YwD4g8Gp0b0M8VQHk2ja29DiknLc+
	4fYERokIKMDGM5OIc7ehvetw6piji7hDB+umMz5Y1HBDHZLHOXkHMnjtJLT0W6Ij7Kk09OyU6Sp
	LTfxWOp/Ufdeu5y/PsLYdkk47CyZehcGf6l3JH0//
X-Gm-Gg: ASbGnct70uz9QgQ4HqxSAJgHPQOJqb8uyfsl3bcOvFBsByOzsIKJ/EI4yOwFkxc+1CH
	71FARN1/S9G0/P7iNoMEHXnK1ADNmpmGxc1eWBA7K3aHAGtaQWV6m+kUVNbtuk47UQ1sQTTEjpG
	mHHWPSfTn9B+FF6JVUzOVuMU9/KKT18gUfr6US/KOZWviQTDNRKq7GFfIQhABKVo/OhG9+Ie95c
	fNWS1isNlRf
X-Google-Smtp-Source: AGHT+IEYnKxZeMI22cVOqi2KgqbYGF7ATdIrfk1pS5aaosjaTntvjwtL7OmyjDPScNP/9EgIMAXTOOMt75dvMIeUqaE=
X-Received: by 2002:a05:6122:8c19:b0:516:18cd:c1fc with SMTP id
 71dfb90a1353d-531498af39fmr12536842e0c.8.1750286298616; Wed, 18 Jun 2025
 15:38:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1746821544.git.jpoimboe@kernel.org> <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
In-Reply-To: <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Wed, 18 Jun 2025 17:38:07 -0500
X-Gm-Features: Ac12FXz8EY8EOZIyXs2WYExliGXD0DSkt01oqP4HIN5HacKUWBKwLvpl3N7gxLI
Message-ID: <CADBMgpxP31YyRMXkHnCvjbb7D8OaUuGKbR9_66pRjGsBd57m8A@mail.gmail.com>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 1:30=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> +
> +# Make sure git re-stats the changed files
> +git_refresh() {
> +       local patch=3D"$1"
> +       local files=3D()
> +
> +       [[ ! -d "$SRC/.git" ]] && return

As a user of git worktrees, my $SRC/.git is a file containing a key:
value pair "gitdir: <path>", causing this script to fail on a [[ ! -d
"$SRC/.git" ]] check. Can this be handled, perhaps with a check if
.git is a file?

It seems like the check is just to confirm the $SRC directory is still
a git tree, in which case maybe adding a -f check would fix this:

[[ ! -d "$SRC/.git" ]] && [[ ! -f "$SRC/.git" ]] && return

Or if the actual git directory is needed for something, maybe it can
be located ahead of time:

GITDIR=3D"$SRC/.git"
[[ -f $GITDIR ]] && GITDIR=3D$(sed -n
's/^gitdir[[:space:]]*:[[:space:]]*//p' $GITDIR)

Thanks,
Dylan

