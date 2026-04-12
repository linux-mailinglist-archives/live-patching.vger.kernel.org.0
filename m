Return-Path: <live-patching+bounces-2331-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gPGREMiN22lODQkAu9opvQ
	(envelope-from <live-patching+bounces-2331-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 14:19:20 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4433E3C48
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 14:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 606FB3018C35
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 12:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DAA037C0E9;
	Sun, 12 Apr 2026 12:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1w7iWpP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202BA37C0E5
	for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 12:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775996339; cv=pass; b=dPaL4mi5VIk2ZCyvR2ZAgzIikZ1QhCPQ2zaiksSeqPxDZhIERuM5McVnxzpd1g/MtAParn0Qljjns0CiCrq6iXS+p24NNNcwfMRFXpqI4u0GnR23OyFpfiv6Lon5FnXfIACcDnVTaiThaDfrFJxRHq2K4UU2CsOqaWIOoV9CjdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775996339; c=relaxed/simple;
	bh=uafX2bQpJrLfg9yfw+DCfmB3m9g7ysXsoTFfZ75pRt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jqQGCRGoRGgCSxhz6pwGRi8ACV/OwT/1tqc0uVh1/QlFS5EC9lsHgm77YAz2NLORopy0scPjMKHxdEscYxmKglcLuMmUBZaexs5aaXtSnISxTTQ4Y6qMeb76pQslxrhDPDhIBtEluj88+QFyW+sBxmRQ34DGD2OGI6uykHG5QjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1w7iWpP; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-65005a8840dso3247758d50.0
        for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 05:18:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775996337; cv=none;
        d=google.com; s=arc-20240605;
        b=FRAFOvYXAuER6SfGWuOTuTGgIvYBmeJqCMKrOs6wGjNfyPIj0tL6fdT0arTgGbkksZ
         y7nCeU24up9ZHNiA2qQL4Z2WjqeqahhS1l+Q7RQYU/FW+ZAtqY2TlVYJKDSL67eaibB7
         bcivitaMkxFl4vuvF5Ks6yQa6F9VTGqFatnZudOGY30ADrdTrb5q5I4MuFqMDk3QLsdZ
         pvgaGoci0KRjV7BAYTggYGsqisblxOQAJJ0Nh3oLp1Jo8xTiaTo9Ag0oHAlGz+eTThkA
         WRIcXVUCxH2oF0GLyu9c22dXmbhDh5AFCYQURrhyHu7TrVRs6GuS99F8hqm3sWs9HFc1
         hmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pDCtYpSt5MQDUqGRaPZuhMEbLqOBYANHADybtg+qQXY=;
        fh=5OrxVcFL2UQScJMhpgDuovbeyzANUEVjvZ8Sqq03u7M=;
        b=U3/ocRPI6+13/Eu6icy2ZNv4o2DDy8BazBPkoPhHqsem+MEbDm5P3rIabdlR5BQXkN
         /tlBdiASvqv6xoxv5yR55GzrmHkD1AUpl5iFUItGh+ykLEHZyFwXIQ7JCHs8fnsd8CNI
         P2cyXJ0wmwXsEY87uY5En226MhNtqykhChf/hPGfaesgvtHl/9sEoGC5VMovaddcZyIF
         P+0xyN4YndMFoXELxe8BrQcsDGs/mE6icIqQLPpCpw3SRCqP86hLe8ID1vrPHI4WPg04
         gGKonqrA6uC4RZHsCj0vZFgZbYKusDanuCX2LOiPCor2l22A4SIyrbAMLr/La2g5s7RQ
         Ob/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775996337; x=1776601137; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pDCtYpSt5MQDUqGRaPZuhMEbLqOBYANHADybtg+qQXY=;
        b=L1w7iWpPjeegHoc9cP6BaGEAqFGK/8eCGY7df9Mu6T7TiPe6jg8yrlfT5j7X6WhBZS
         JCZf2TZlC/ol2ltgkb2jLz+ZBfnaddtYmm7F2xg9ysRtaKPYEIIj6Kc3fMIWXVRQhfS/
         Rv0lcdIXCgI16EFL0Z8jQJqxDECvrtcyPN0s9S5J4Q9Ac2X/MxNBac78S1FhVR1+aDbn
         mKfrDac9sl7Lf8IZ8AxVCoHAyODdkNQMhgvyOhwOlgaUNvf871kGs/tzQ9Y5Q99GPL7T
         roUWoyD+oGDJmTDhegrO0nRZOlBkMQKlLi8EulyjkxfBm0psBw1b1Xa7X+laho44JjdZ
         +Kqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775996337; x=1776601137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pDCtYpSt5MQDUqGRaPZuhMEbLqOBYANHADybtg+qQXY=;
        b=MF87B7NEjcLVDBAvhbHJB0MM/8HhM6bVeb6mKJv2wGG8vDMLErjrfU9BZs9y7Pj6mg
         y8oW6a9T7pREepEXUwoOzsQXirRWoEtzSdAPi4ZMo1ngY1XTU0a2ffA7j9q229f57LyD
         zgKUpPc9+LYzEH3xgKcAeZq3+vbobWcUQ8k3BX98UaXKibo6o3Z2+/rlzvrg7h+ITDuC
         p6jqYmUFKnu+qyXdCOIgk+eLhBc+52K5xWlFQ1AndUHwmj4Cxsi8SKMk2r1+Q/ol431S
         qk5aL/Su2JpkA5hH64MF07O4TMh1KNnQoLGGYnVF69n/4pqABWOe8GKRJAUL1XLz0BjR
         h2wg==
X-Forwarded-Encrypted: i=1; AFNElJ9pL++p3UneLxXNnRTFC3NX0AQRBieIy1Eq3oAtDO9wYafsh2puDS3DbzX4PXQj7YnZbq3WcZHkjHE/8OoG@vger.kernel.org
X-Gm-Message-State: AOJu0YybnDjQRzz0yWXpZEVlAnFMkxs1LkSOZrPTWWD68ZwJVa+WFKHm
	N6c32YPLY676/KDjL/BPEO8acxJy/K4PySHPGARitnBlW7qFWhnmaqNLMYgP1mflbpkJKR1WQ4T
	HUVE9VreRwRIOOY5qOsQL+eAFCGz0gkk=
X-Gm-Gg: AeBDieubvXOrCej/St2Fel3dDU87SzNWVD6Esvr3ynICNe2mb7UEj/Q8OUsptaCv1Z2
	mQRxwjYUoPr4fdFitLb5wqwORSkBrhHz3cihr7XI48J+eBHPfUwTDABUrDtY9aCidAS9t4ctBm5
	WEdcDGAHXksq8uBzTCOWlUToKMkkuwHHwCxJH4nGTOY3XSZalmTroaYCwR8Tq7XosSCmyVkWNUe
	sXsZxeBWrfatfdL+nn6saifDJzofd6HuI7bVR+ExUMbkmBD81lrUVuoDozVA4duCTn6SXVTLvI/
	SRW80ZGQ8NkL/Vgu2RAI4SpjEPlzdWVjoMV1DH/g
X-Received: by 2002:a05:690e:e8b:b0:650:70da:bc25 with SMTP id
 956f58d0204a3-65198c71a1amr8599414d50.58.1775996337015; Sun, 12 Apr 2026
 05:18:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com> <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
 <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
 <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com>
 <adUd0Mojbtrwmeod@pathway.suse.cz> <CALOAHbDG9mq1iJv5suct=cqJ+2r8VvJ-dXN=nuvMw0XYqnUjxA@mail.gmail.com>
 <adY_WgA54CDtWBq6@pathway.suse.cz> <CAPhsuW42WqGuZ1Z-RG0yzifZ7rh=XKUa5hKb6JxLeTWdc4s4-A@mail.gmail.com>
 <addW_-whBavyHY-Z@pathway.suse.cz>
In-Reply-To: <addW_-whBavyHY-Z@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 12 Apr 2026 20:18:21 +0800
X-Gm-Features: AQROBzAAbQj2joTRPhJ-lyVJz17Ih4lLYbyXLH4mJVa2clLa9rohXScgqMMq5Wg
Message-ID: <CALOAHbB-b6YUx4zQjp-AgV0gYp26pKjwrjABd8+XJHNsW=0EtQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
	Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2331-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,redhat.com,google.com,suse.cz,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: CF4433E3C48
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 9, 2026 at 3:36=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrote=
:
>
> On Wed 2026-04-08 11:19:50, Song Liu wrote:
> > On Wed, Apr 8, 2026 at 4:43=E2=80=AFAM Petr Mladek <pmladek@suse.com> w=
rote:
> > [...]
> > > > >
> > > > > This is weird semantic. Which livepatch tag would be allowed to
> > > > > supersede it, please?
> > > > >
> > > > > Do we still need this category?
> > > >
> > > > It can be superseded by any livepatch that has a non-zero tag set.
> > >
> > > And this exactly the weird thing.
> > >
> > > A patch with the .replace flag set is supposed to obsolete all alread=
y
> > > installed livepatches. It means that it should provide all existing
> > > fixes and features.
> > >
> > > Now, we want to introduce a replace flag/set which would allow to
> > > replace/obsolete only the livepatch with the same tag/set number.
> > > And we want to prevent conflicts by making sure that livepatches with
> > > different tag/set number will never livepatch the same function.
> > >
> > > Obviously, livepatches with different tag/set number could not
> > > obsolete the same no-replace livepatch. They would need to livepatch
> > > the same functions touched by the no-replace livepatch and would
> > > conflict.
> > >
> > > So, I suggest to remove the no-replace mode completely. It should
> > > not be needed. A livepatch which should be installed in parallel
> > > will simply use another unique tag/set number.
> >
> > I think I see your point now. Existing code works as:
> > - replace=3Dfalse doesn't replace anything
> > - replace=3Dtrue replaces everything
> >
> > If we assume false=3D0 and true=3D1, it is technically possible to defi=
ne:
> > - replace_set=3D0 doesn't replace anything
> > - replace_set=3D1 replaces everything
> > - replace_set=3D2+ only replace the same replace_set
>
> Yes. This well describes my point.
>
> > This is probably a little too complicated.
> >
> > > > This ensures backward compatibility: while a non-atomic-replace
> > > > livepatch can be superseded by an atomic-replace one, the reverse i=
s
> > > > not permitted=E2=80=94an atomic-replace livepatch cannot be superse=
ded by a
> > > > non-atomic one.
> > >
> > > IMHO, the backward compatibility would just create complexity and mes=
s
> > > in this case.
> >
> > Given that livepatch is for expert users, I think we can make this work
> > without backward compatibility. But breaking compatibility is always no=
t
> > preferred.
>
> I believe that it is acceptable because:
>
>   1. It was always hard to combine no-replace and replace livepatches.
>      I wonder if anyone combines them at all.

Because 'replace' patches can supersede 'no-replace' ones, users have
to maintain a strict loading order. I doubt anyone actually combines
them in production.

>
>   2. I believe that nobody tries to load the same livepatch module on
>      different kernel versions. Instead, everyone prepares a custom
>      livepatch module for each livepatched kernel version/release.

Correct. We always build and apply distinct livepatches for each
specific kernel version.

>
>      And the tooling for creating livepatches will need to be updated
>      to use "number" instead of "true/false" anyway.
>
> That said, it is easier to always use "0" for non-replace patches
> instead of assigning an unique "number" to avoid replacing. But
> I do not think that this would justify the complexity of having
> different semantic for 0, 1, and 2+ replace_set numbers.

Fair enough. Let's drop backward compatibility to keep the
implementation simple.

--
Regards
Yafang

