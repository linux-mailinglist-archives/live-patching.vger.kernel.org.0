Return-Path: <live-patching+bounces-636-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA64970993
	for <lists+live-patching@lfdr.de>; Sun,  8 Sep 2024 21:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CF5A1C2186D
	for <lists+live-patching@lfdr.de>; Sun,  8 Sep 2024 19:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3AF517A922;
	Sun,  8 Sep 2024 19:45:02 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412F52206E
	for <live-patching@vger.kernel.org>; Sun,  8 Sep 2024 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725824702; cv=none; b=QMmWkencZyQ2Axvm7BPH3wANQWfRGnrczB0AqT0LyeQ2Rn4BqXjhIzphjlpc7zu+6PmmC35EIGweu1t6lIYwkMnAzzhfyitd1XjZaZ+ebV5rBDT1SA9abUmVW62qcHkzLP5IKxlC9qfLUX2Yt1usfa5S8UMrrGtbfqWcML8iyfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725824702; c=relaxed/simple;
	bh=T4lbU3Mns5fbxeZNTnz6NaF1mRkxmXr3WV5PejjH3RY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=aJqxTIObFrBrsoP/DqpBItiRdWWlNOQgGO15H6esP3kbaFo7jPmipY7cC4zdTTQp5Uhcm+4VsoZttELryX8bECKOg9rdIyZLeAPHbHZWhMwnlZQVyNY3hncvnV4/v+xsVeKBEZAKHyFied4RU8M12C9mgA92xkqSVceSmg1K0tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-323-cfZ70aNhPeG4p8VQmNOQdg-1; Sun, 08 Sep 2024 20:44:50 +0100
X-MC-Unique: cfZ70aNhPeG4p8VQmNOQdg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 8 Sep
 2024 20:43:59 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sun, 8 Sep 2024 20:43:59 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Peter Zijlstra' <peterz@infradead.org>, Josh Poimboeuf
	<jpoimboe@kernel.org>
CC: "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, Miroslav Benes <mbenes@suse.cz>, "Petr
 Mladek" <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, "Jiri
 Kosina" <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, "Song
 Liu" <song@kernel.org>
Subject: RE: [RFC 05/31] x86/compiler: Tweak __UNIQUE_ID naming
Thread-Topic: [RFC 05/31] x86/compiler: Tweak __UNIQUE_ID naming
Thread-Index: AQHa/da8Kbv7PqyNRkCNp5PR2zK+C7JOUHcg
Date: Sun, 8 Sep 2024 19:43:59 +0000
Message-ID: <9b8f1beb0d444a84ab500ebdac756eba@AcuMS.aculab.com>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <d8d876dcd1d76c667a4449f4673104669480c08d.1725334260.git.jpoimboe@kernel.org>
 <20240903075634.GL4723@noisy.programming.kicks-ass.net>
In-Reply-To: <20240903075634.GL4723@noisy.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Peter Zijlstra
> Sent: 03 September 2024 08:57
>=20
> On Mon, Sep 02, 2024 at 08:59:48PM -0700, Josh Poimboeuf wrote:
> > Add an underscore between the "name" and the counter so tooling can
> > distinguish between the non-unique and unique portions of the symbol
> > name.
> >
> > This will come in handy for "objtool klp diff".
> >
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  include/linux/compiler.h | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> > index 8c252e073bd8..d3f100821d45 100644
> > --- a/include/linux/compiler.h
> > +++ b/include/linux/compiler.h
> > @@ -186,7 +186,11 @@ void ftrace_likely_update(struct ftrace_likely_dat=
a *f, int val,
> >  =09__asm__ ("" : "=3Dr" (var) : "0" (var))
> >  #endif
> >
> > -#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __C=
OUNTER__)
> > +/* Format: __UNIQUE_ID_<name>_<__COUNTER__> */
> > +#define __UNIQUE_ID(name)=09=09=09=09=09\
> > +=09__PASTE(__UNIQUE_ID_,=09=09=09=09=09\
> > +=09__PASTE(name,=09=09=09=09=09=09\
> > +=09__PASTE(_, __COUNTER__)))
>=20
> OK, that's just painful to read; how about so?
>=20
> =09__PASTE(__UNIQUE_ID_,=09=09=09=09=09\
> =09        __PASTE(name,=09=09=09=09=09\
> =09=09        __PASTE(_, __COUNTER)))

Why not just generate name_nnnnn?
I believe it that the 'prefix' was added to allow multiple unique names be
generated on a single line on versions of gcc that didn't support __COUNTER=
__
and __LINE__ was used instead.
So prior to that the result would have been __UNIQUE_ID_nnnn with no indica=
tion
of the variable name.

In one of the min/max changes I suggested just passing __COUNTER__ through
the required 2 #defines and then just appending it to the variable name.
IIRC Linus liked that idea :-)
Need to find time to write the patch...

After all __PASTE() itself is only really necessary for a K&R C cpp.
Possibly still relevant for .S files - not sure.
(You had to generate a/**/b to get ab when the comment was removed.)

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


