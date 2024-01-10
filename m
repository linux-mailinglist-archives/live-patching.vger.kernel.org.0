Return-Path: <live-patching+bounces-132-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCFD082A06D
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 19:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B9B4287BFC
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 18:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8684CE11;
	Wed, 10 Jan 2024 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Jg+Cez0O"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E83D45BEC
	for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 18:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a28da6285c1so801943166b.0
        for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 10:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704912706; x=1705517506; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SUi+vVjnlXvuMiah1i251N0KCiLVzvP6N7O0UZtD65o=;
        b=Jg+Cez0OsoADfYSEjMo7zNEnDOQfu95tEapunyPFcfYxd7t2yy5vw2BbuqTHL9wi2H
         nozEpiJwpX0xQmavLg+j7IyY+lQDJXYUOV8CtilXqfESpEntsBKyejAU+t8YbxfFOVx7
         +Bqra0qO9HOCVFbCXji5nr3gYqeP/6QEX6qacLOa95IDs2p6k3Pu9b4dgJZtgL21sYlc
         BP/QhrIGIb0aqOdFSMWeZhFEDuc+QeUFoRTdLGvr/mhKBmhdwtp5m0JOpr5lWCkAu/RR
         PzLRzAG8m17+UYeRYvylYNnz1SKQA2kXzcX4U5CityUQCV2Zb9QaTkbBhR4m1PPRzNNO
         eMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704912706; x=1705517506;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SUi+vVjnlXvuMiah1i251N0KCiLVzvP6N7O0UZtD65o=;
        b=Ce6pVZ71lnypZMDy5NAN4GZ8HOMbm161cLsC+PP+zRm72CIcyTVNlPyhWu9nkh9t5Z
         n0ome3k5RRk4fALAJKg7aEvVE9jJm6RQDY6S4Ds1RGs6Kxll7JrLKiGR5IdL9N6pJxeM
         bmRfUi4OA+0uOrOSCQ0dP75OFPp35EM+nO8CXeWgl82Fr5mojd+//diU9FxwMCkl4/QG
         Hs6UucI/ZScpmRPrxYda2lVY9RjRtE50AqmhAfzU9RSpCvnEkwILB+JR50jcsl5Y1VXF
         81aZNRgEwbBLHeBOWawhLySUefspt3A8WAJmmwAfhVtNKhYB6Mk5MtVrBk/jknwCqHf0
         +avA==
X-Gm-Message-State: AOJu0YwhnCAS/FqM7/P3N6jmcvV1Xl79G4VzhU07NE/P/C2gsHYgEPoj
	xoj5to9DKYYssm5Op6PC6kezLikst4AWQg==
X-Google-Smtp-Source: AGHT+IFIr7fU1mieZ/hu3Aq23BdynryneyJZb4/Z7tb05MemWRgr1IqJ5Tw04abHCb3B4mcLOIOUzA==
X-Received: by 2002:a17:907:868b:b0:a29:b898:93cc with SMTP id qa11-20020a170907868b00b00a29b89893ccmr617682ejc.28.1704912705877;
        Wed, 10 Jan 2024 10:51:45 -0800 (PST)
Received: from ?IPv6:2804:30c:1668:b300:8fcd:588d:fb77:ed04? ([2804:30c:1668:b300:8fcd:588d:fb77:ed04])
        by smtp.gmail.com with ESMTPSA id z12-20020a170902ee0c00b001d536a910fasm4002413plb.77.2024.01.10.10.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 10:51:45 -0800 (PST)
Message-ID: <49cfdce3094fcc37ecf01bb358509c64ee8feed9.camel@suse.com>
Subject: Re: [PATCH] Documentation/livepatch: Update terminology in livepatch
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Jonathan Corbet <corbet@lwn.net>, Attreyee M <tintinm2017@gmail.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
  joe.lawrence@redhat.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,  live-patching@vger.kernel.org
Date: Wed, 10 Jan 2024 15:51:40 -0300
In-Reply-To: <87jzohoy02.fsf@meer.lwn.net>
References: <20231223205813.32083-1-tintinm2017@gmail.com>
	 <87o7eg607d.fsf@meer.lwn.net> <ZYpb6Woh45ZnEvCP@archie.me>
	 <CAJjsb4reD_TVWRFonp90xXD4Ye2OOfOd894PzmfMKaP3qFkbYg@mail.gmail.com>
	 <87jzohoy02.fsf@meer.lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-01-10 at 11:15 -0700, Jonathan Corbet wrote:
> Attreyee M <tintinm2017@gmail.com> writes:
>=20
> > Hello maintainers,=20
> >=20
> > I wanted to ask if this patch of mine is accepted as of now.=20
>=20
> You never responded to the question that is still quoted in your
> (unfortunately top-posted) email:
>=20
> > So this is a classic example of saying what you have done, but not
> > why.
> > What makes this a change that we want?
>=20
> So no, not accepted.=C2=A0 Even with a proper changelog, though, I'm not
> sure
> I see the value in that particular change.

From time to time I see people complaining about the lack of new people
coming to kernel development, and that Documentation would be a good
start for some of them to learn how to send patches by email (which by
itself is difficult...).

As Documentation patches aren't backported, why not accept this patch?

Jon, I understand your reasoning, but I agree with Attreyee here. The
term "acquire" fits better when in conjunction with "released" than
"get".

Can you show an example of a good commit message to Attreyee so he can
adjust and resend? I'm sure the next time he'll consider remember the
suggestion given and the next patch will have a better commit message.

Thanks,
  Marcos

>=20
> jon
>=20


