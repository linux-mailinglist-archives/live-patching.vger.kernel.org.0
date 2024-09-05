Return-Path: <live-patching+bounces-613-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1AA96E523
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 23:34:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD23F28AB2D
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 21:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FD41A0AF3;
	Thu,  5 Sep 2024 21:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkp+2dAk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968C19409A;
	Thu,  5 Sep 2024 21:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725572088; cv=none; b=YEMteUEXl1x7ms4kck+jjP6zT5GV6lOX4pUeVmmpXjGE+fKajwNOVgjXkRslw8jux0KeXV/lyJNd7GcPHa0XJyXWteYjlkRYUXCF8UyTVzPSDVPPAeYIT0PdjPteYu8RZC+MiDT38N9pPi8WXsOkk4zQAfr4V48NQbG629Jlu8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725572088; c=relaxed/simple;
	bh=ZMiX4d3Z+IjEsCBW5abbhCxoH0/nkr4YNPtIffNTJZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vCCBaj63xQ3leASFEqG2YcBD5Yghe+wqxmDIwMVISaUJXjtrRgTmEf8Vi04geCnK+llQ3lBQ2HZvpTTB6o9fMNuLdrQPwPa3fWHhQOX4AcVkOYz0ruc7ayMsQvk+nQowa9lE3g83W30vZxe+186/V69F+vOhHR93WX09QHmVzd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkp+2dAk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEE0C4CEC7;
	Thu,  5 Sep 2024 21:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725572088;
	bh=ZMiX4d3Z+IjEsCBW5abbhCxoH0/nkr4YNPtIffNTJZE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rkp+2dAkfxMckcIMCMNp1YWDiG0x/azZKe1KnZ2Q1n66O+/1Gfe1B6EOyDBdTN/dF
	 T3+ezI08cuNzKUk68w0no8krIb07CNat31W3PI9ehCx/qjkK5Gl4y3zqBh8sbB9cdR
	 H7NNjoYjKXWM2CHuJGgPbOW0modCx00tflddqxbWecVsgn0KdFINHZh/QVhGSq9GTp
	 UKwBlMzFVyUv3q1N3yVSi87U/Kk2H6CBvwvRHZWCH4FZ5mKhmtAa0TjReeFk/rQWAo
	 0tFfnP+svsOCGmOLogbt+ae9dxEXgZxfPnSMAWB7snahLJtPCuoCi0O22/qk5towO1
	 fwCkSRaQGq/yA==
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-39f54ab8e69so8259835ab.1;
        Thu, 05 Sep 2024 14:34:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUmYxQLbEoA9rjqISQXX2HsgCemBLpgCTLBr/cnPNcB2PwJsJprE4djZqPTFqu9wglWAgQaTnTjKye5YOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzMrqRH2eB5AR/8X3yTeka9kG4eXp5T1QrVlTY6YcBB1KfrLD4
	BKTde562X9yVYKQWK75SIP3/8zysNrQFX6t/94AcVPD/9d1ryCaVs96dhkiaQcA9fisKzhs2CBA
	kW8lqP6dPwPOqzlHY84NtVU70oos=
X-Google-Smtp-Source: AGHT+IHhjtKp0fAXkW/Hb58rNk103UzmqcNkWzk8etRplvdQ0kPQKQxXwrQY97ppCC7sFl9V1PtNF2DpxyZDpWdoIFg=
X-Received: by 2002:a05:6e02:18cc:b0:375:a3eb:bfcd with SMTP id
 e9e14a558f8ab-39f797b23a7mr73050795ab.8.1725572087479; Thu, 05 Sep 2024
 14:34:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725334260.git.jpoimboe@kernel.org> <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240904043034.jwy4v2y4wkinjqe4@treble> <CAPhsuW6+6S5qBGEvFfVh7M-_-FntL=Rk=OqZzvQjpZ6MyDhNuA@mail.gmail.com>
 <20240904063736.c7ru2k5o7x35o2vy@treble> <20240904070952.kkafz2w5m7wnhblh@treble>
 <CAPhsuW6gy-OzjYH2u7gPceuphybP8Q43J9YjeUpkWTh5DBFRSQ@mail.gmail.com>
 <20240904205949.2dfmw6f7tcnza3rw@treble> <20240905041358.5vzb3rsklbvzx73e@treble>
 <20240905071352.shnm6pnjhdxa7yfl@treble>
In-Reply-To: <20240905071352.shnm6pnjhdxa7yfl@treble>
From: Song Liu <song@kernel.org>
Date: Thu, 5 Sep 2024 14:34:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW432TUgzvHS7kQ0RhpzjMHhkdcrDTBV0S=+PuooVFd5WA@mail.gmail.com>
Message-ID: <CAPhsuW432TUgzvHS7kQ0RhpzjMHhkdcrDTBV0S=+PuooVFd5WA@mail.gmail.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 12:13=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Wed, Sep 04, 2024 at 09:14:00PM -0700, Josh Poimboeuf wrote:
>
> > +     if (!!nr_objs) {
>             ^^
>             oops
>
> Fixed version:

The fixed version works for the following cases with gcc-12:

1. no BTF, no IBT;
2. with BTF and CONFIG_MODULE_ALLOW_BTF_MISMATCH, no IBT;
3. with BTF and CONFIG_MODULE_ALLOW_BTF_MISMATCH, with IBT;

There is still some issue with BTF, so we need
CONFIG_MODULE_ALLOW_BTF_MISMATCH here.

But it appears to be mostly working.

OTOH, there are still some issues with LLVM ("symbol 'xxx' already
defined", etc.).

Thanks,
Song

