Return-Path: <live-patching+bounces-131-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19DCF82A02F
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 19:20:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B11F8B23909
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 18:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0E14D13B;
	Wed, 10 Jan 2024 18:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h56S5/UN"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7EE4CDE0;
	Wed, 10 Jan 2024 18:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-5e7409797a1so42652537b3.0;
        Wed, 10 Jan 2024 10:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704910836; x=1705515636; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IiZM2DBC2hxsgD1bO1IIo8YWHN+uFraLDJ3bquLyLXc=;
        b=h56S5/UNHZJn92L0ttpi07Trvn8TcnGr3aG1PwkI+4BPE+9mlcMI1s6XwjXvmAs33w
         h6cOCUf2XhDu5Ievx2lH8uCxdrAdShgU4s4nqUhr8pq2Xt3fdONXcUe5LlkS2gYQMZg3
         E5SqDwEAod7kdM+Bz5wQR/FNh9fGil+DxVP1zEvivYOKNR2vpAz4FaG/aRwww7R8r0Vg
         MqSiUdlDdLUix9SdTa0lUB/QouUsju3Wv4u6mqPyBJXYurD9rl7itjM3zEiyTTzKfnMG
         jbflMC3cypHykOngq4IuuUqth2psZ7Pra/arogh2+vHm98HRxCCm1IotLFNp8HXeqyCP
         zCbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704910836; x=1705515636;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IiZM2DBC2hxsgD1bO1IIo8YWHN+uFraLDJ3bquLyLXc=;
        b=RzNOki3Vtud1pFDgPuVysZZFovCAoVvhWyXDJlLv97Rg5lODOhtNPlOy2ryUemnV8+
         J9/on3WP7mAwQX5HYUP6BO8mLmJp/KnAscrZTpqjtr1eIcT859QBCNy8Jev9WIAq5uWq
         7VIq0WJ/Uu/QdWQi2L7piwt1Sob2GDGlSUquGphI0+fyGSgysrNTxTeIvfxsDRjXTwKh
         G0Zr3aCPBB1pfrP7OKGGLlVAq8CsofsVt2SUjPruHY4ilXqjFyxhq5sKseCz6uVWm8Cx
         ke/uE62ysr11zDVSs3cHF3Ug9syjMxFMuSRuPhdpIQN6PfWrlsZlCeRJp+1+EuTCWffK
         KCsQ==
X-Gm-Message-State: AOJu0Yx2KpPIoeV9pAxJNFCH71WgTF7bp6GxTFM1si5JW/qRH5M8TmP7
	fYfcqlpDYInZyFsYxwGDz/QVnn4XdV+vf3Kkcdk=
X-Google-Smtp-Source: AGHT+IG6qWhoyZ+fToSKpyzhVm3lGpXdrO/8GggvUr1nvI/2oGWXQMC3FAUtdhvFZgoHwmUFXSNEo2Ro5vF0CYz2Hf0=
X-Received: by 2002:a81:4523:0:b0:5f8:420e:468d with SMTP id
 s35-20020a814523000000b005f8420e468dmr35606ywa.47.1704910836404; Wed, 10 Jan
 2024 10:20:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231223205813.32083-1-tintinm2017@gmail.com> <87o7eg607d.fsf@meer.lwn.net>
 <ZYpb6Woh45ZnEvCP@archie.me> <CAJjsb4reD_TVWRFonp90xXD4Ye2OOfOd894PzmfMKaP3qFkbYg@mail.gmail.com>
 <87jzohoy02.fsf@meer.lwn.net>
In-Reply-To: <87jzohoy02.fsf@meer.lwn.net>
From: Attreyee M <tintinm2017@gmail.com>
Date: Wed, 10 Jan 2024 23:50:24 +0530
Message-ID: <CAJjsb4omO_0+EMBX-g1jnxUeYsPr=uWCtwHCxUjmLirdVAUGLg@mail.gmail.com>
Subject: Re: [PATCH] Documentation/livepatch: Update terminology in livepatch
To: Jonathan Corbet <corbet@lwn.net>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

As Bagas Sanjaya wrote in the email before about the change, I thought
the reason was explained.
I am sorry that I didn't respond to it thinking that.

Thank you
Attreyee Mukherjee

On Wed, 10 Jan 2024 at 23:45, Jonathan Corbet <corbet@lwn.net> wrote:
>
> Attreyee M <tintinm2017@gmail.com> writes:
>
> > Hello maintainers,
> >
> > I wanted to ask if this patch of mine is accepted as of now.
>
> You never responded to the question that is still quoted in your
> (unfortunately top-posted) email:
>
> > So this is a classic example of saying what you have done, but not why.
> > What makes this a change that we want?
>
> So no, not accepted.  Even with a proper changelog, though, I'm not sure
> I see the value in that particular change.
>
> jon

