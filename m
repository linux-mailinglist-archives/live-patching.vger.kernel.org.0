Return-Path: <live-patching+bounces-129-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA81829FEC
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 18:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C2CE1C219BC
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 17:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4854D100;
	Wed, 10 Jan 2024 17:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JijqD3JM"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E3C4D111;
	Wed, 10 Jan 2024 17:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-dbf2737bd48so813298276.2;
        Wed, 10 Jan 2024 09:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704909396; x=1705514196; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PQeK+7VeBANXiUt3jJrnMLi7/kdv42W/bH2mDkBAuEE=;
        b=JijqD3JM5lKW4irwaGQjTcYp2QbRl13nMsjIXhbxDr3TCMIDBp0WHCFzHjGQF/Lovf
         pTXOdeLCHskSx5uOpWRKtPVCk/sS4I88KeDG3zp4deejC/grH7xVvXSE6M7QXeeItGtC
         5XuGvwlxZkFBstj6k4QSgaDK0Tfp5YwRJX3lSQhIAflrgmXhRZArZBx5gMX/IEF7XAzG
         jZ0W7PeDil3RHOSMtYFUR6pHH7Z2HaepLnVnlJMnxopQzHLbDqDciOVgb7xwMLprUtu2
         hTpDWE3h2wQp3g07n0ShywUMEs0etbwTar0smVE0ruw4oMv/3Bs0G7th+QV9fAUuCDng
         6+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704909396; x=1705514196;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PQeK+7VeBANXiUt3jJrnMLi7/kdv42W/bH2mDkBAuEE=;
        b=XuubulZv3HoZtLeIAFdXDVU0CivRmNb9sHJL/kZ7j8YnPIp0R5Q/vkhawurjab2bvb
         82KFsLTD6rha1I2OL7rz2JQwHkeIOo9B9IOe3GhCEG2DzH2fEOhun6qlN5MZKcuGXHwb
         JfS4Cz5WoBgyTb09i04dgtqTWa/eu8ef5QDAVFAo7Xc/LUphEEQj1lftyQGzJi/mT/uv
         UQWOLW7QjUNJ8mZSNKMJDsQHdaOyLHK//IfFYISSfVzgjpjHwrwNM5w15she4V6xarlU
         iOqdv0ByXsK//8jt5mZzQaNyCGzLjASukf2JrJYNjlulkh3TohEzX6pJ9TO6jRPDw7PN
         o2rg==
X-Gm-Message-State: AOJu0YyrXh1APgW5VYWIZ7dDAmvTLBpIIn6E21iQD2hCBOvgpeeEXYw9
	OSlJcUeJEnneuEOOF0egn7+jfgtUSqhNj5LHElg=
X-Google-Smtp-Source: AGHT+IGZ547b/FyO6Vt/7849lDC7WdCxT8CR+oj1CCtE9zESaINxdCHXguIvsOwU+tvrVQwjchskpczEmr26mwH/vm8=
X-Received: by 2002:a25:b907:0:b0:dbd:b751:7ce with SMTP id
 x7-20020a25b907000000b00dbdb75107cemr960897ybj.73.1704909396614; Wed, 10 Jan
 2024 09:56:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231223205813.32083-1-tintinm2017@gmail.com> <87o7eg607d.fsf@meer.lwn.net>
 <ZYpb6Woh45ZnEvCP@archie.me>
In-Reply-To: <ZYpb6Woh45ZnEvCP@archie.me>
From: Attreyee M <tintinm2017@gmail.com>
Date: Wed, 10 Jan 2024 23:26:25 +0530
Message-ID: <CAJjsb4oWN6Owg45SQomLx0G7ZkCnfepLiJJ=uZukHTYfvq2OfA@mail.gmail.com>
Subject: Re: [PATCH] Documentation/livepatch: Update terminology in livepatch
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello maintainers,

I wanted to ask if this patch of mine is accepted as of now.

Thank you
Attreyee Mukherjee


On Tue, 26 Dec 2023 at 10:22, Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> On Sat, Dec 23, 2023 at 03:08:54PM -0700, Jonathan Corbet wrote:
> > attreyee-muk <tintinm2017@gmail.com> writes:
> >
> > > Update the sentence in livepatch.rst to: "Functions are there for a reason. Take some input parameters, acquire or release locks, read, process, and write some data in a defined way."
> > >
> > > Signed-off-by: Attreyee Mukherjee <tintinm2017@gmail.com>
> > > ---
> > >  Documentation/livepatch/livepatch.rst | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > So this is a classic example of saying what you have done, but not why.
> > What makes this a change that we want?
>
> I think what he intended was "The word 'get' is not the correct antonym to
> 'release' in the context of locking. Replace it with 'acquire'".
>
> Thanks.
>
> --
> An old man doll... just what I always wanted! - Clara

