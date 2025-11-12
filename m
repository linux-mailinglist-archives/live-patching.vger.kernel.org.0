Return-Path: <live-patching+bounces-1838-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E7454C527E3
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 14:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5FC294F6814
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 13:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C274337BBD;
	Wed, 12 Nov 2025 13:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDCnbzK5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D60337B80
	for <live-patching@vger.kernel.org>; Wed, 12 Nov 2025 13:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762953962; cv=none; b=eOHjwPrjURS3gZaJC6y6LqOZG2d6gyl01NCMuG4e6tY+DuMFyFk/FHj+MpVnst1UkDRvMVdAASnH4qdBo0VuR5RDdFxd8xOCH1nzdUjGzz9KbVL0SkVY/k9uvHckDSaWtcyYFqWO8XZAPJrFDJn7XzIuiwckaDuv8lm/ElrUEPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762953962; c=relaxed/simple;
	bh=T1CGPkh5QxTkBTbF04kkfTJDiDQ1Esip4NrCljeHTKo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ELSn04m8VkT8xxDUczVpziq5QbAjdauFJyNwvZYuvHbnxIgt2bmvlocsOnyf3gZmH9F8ukrK6Tv5bSUD1OApAmDxQu8+tYDP12JVgMPrrS6W1Gymd5AgrFJFQXS4ekreYWQo9u+lG/h8JmNa0EiwuVmg/L0Iw0r5Ry4pA7/F3oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDCnbzK5; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-471191ac79dso7747305e9.3
        for <live-patching@vger.kernel.org>; Wed, 12 Nov 2025 05:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762953959; x=1763558759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67MdzTIe7nfHzCF8gVvcgRb1LTBruURe7nkrUBvNKhc=;
        b=PDCnbzK5vOqB79SOXG7xGjIVcZ0c+m/VUZKVa+sLaOjRCxifUHeRLCNqT3vEi9qDO+
         ZB9wbOooVTN7HlGG9Q7Mr0nA19xZFEqaMH4Z9s6yRMn+2rxFliObimMUdCckdXrXCLOa
         M2ZetXGq5KDqOGn9J/E+xX0eVDimvUYGK1qy519ybSP5rs4ESwwILKtp2kN223dMMwNk
         sAzrBtgfeRXd8Rca0QtlWYTNcRHDBoP14XeH/AVgA/IU3H7lmh2VcHsGS1WroP0a3lso
         wulgksovOwlBfM4bXb4Ym1i7zm2AdePLpmj74/DsifI/8xsYfLRLQiznfPF3c2DwI10R
         CT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762953959; x=1763558759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=67MdzTIe7nfHzCF8gVvcgRb1LTBruURe7nkrUBvNKhc=;
        b=snOqyQglC90WERHs1rvIl9CCIaPCNYz/oNfh2tojIulz6ti+C9J2JcGNii0hNkeNXI
         ivReP2T2ojH2+RRqKt36/7phtkRnBCCkmFJSjyoZOkzomBGGBUnE7MbwC0UzooLeWp0/
         IziLasHOo7SHOc9nuw8S7Tj2uyDNelzRzij0ejhNukUeepTqxE1yN+sOOhUBkSr5DmXx
         EcTH41i3z/JJ/6WUaB9eBcKilyTC7BVQZ+Rg9sal7rgSGV14q2Hlmeqmw++ScQvlQNIr
         ZzuJd6ZUYAGhW7X7H/Cw1/5MALq3bw/0DdSebjHMNCg71Z+6zvJSR04N2F1p+Kdb32oi
         VrWg==
X-Forwarded-Encrypted: i=1; AJvYcCX3neQn787wP4kvW/SKXTrCYR79TXtC7jiUbPP0EDT/xBoylvVl5NtRz6n/rggQCwbgvgkFi7o83KxQCjBT@vger.kernel.org
X-Gm-Message-State: AOJu0YzsEiPnsaTJDs1bULObTfvd0BYIxvDRklZMYQQ1tiyuslOD8KU8
	ljTSQ7cR+EnpxaqGiIwvFFzPIw+PPHfcgUaD9zwMVHktdPshHQ+yvGy7
X-Gm-Gg: ASbGnctml9BqdpexDkAo8FpDUJVkaKPCQWllJLyx2FJethXTs5Ao3U+UJXHc7ig9iSp
	T7Vxii2uB0NbcId6/DjrPn3dA+ygkZ0VFzAeupyUFaY0P7e2ymc85vifiGQgwKPjTCJ69QP3Bv0
	ka8kwKHY+EtxmW3XmAR9oCgtDbxejJ8Xa+apPpvsHYIMNqxLiZrUSsJqHDkhVDppZJMJxe0kNtW
	W9VsVa8PSPzwd3c/1puiJvlHZJa2jY+niui6R+5EexlgToxTCD+dHLyuCJxkvKhYKkI9gVgBTNk
	cCRUVKnBAMd18ML2JntloFEUMr/1vUbyRwVj153z55cAMCJOYIdSJ/rJ7Usov4yEwcZAqlE2WzF
	tcz2S7Pv5bLIUzLAq2Qt61k+K121I/ek7VLov9yCFj9aBPeqDq1P2m+6tHdHDGb9CRcsN7eZUjV
	MMUVQjiFFAqr20aQLgHUoUprgmA3ysmhLLv5WZ+DnDNKl0hf73Xb+q
X-Google-Smtp-Source: AGHT+IGEnOyZeVcb75zllMCg/tu1yw75i9pj+Pj/BhOqY02ZJ8vy9wTGJH1HbwhlEvGnWNxL1iOypQ==
X-Received: by 2002:a05:600c:458d:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-477870a5e92mr32125845e9.32.1762953958979;
        Wed, 12 Nov 2025 05:25:58 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e3a656sm36447935e9.2.2025.11.12.05.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 05:25:58 -0800 (PST)
Date: Wed, 12 Nov 2025 13:25:57 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Petr Mladek
 <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, Joe Lawrence
 <joe.lawrence@redhat.com>, "live-patching@vger.kernel.org"
 <live-patching@vger.kernel.org>, Song Liu <song@kernel.org>, laokz
 <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza
 <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, Fazla Mehrab
 <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay
 Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, Peter
 Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Message-ID: <20251112132557.6928f799@pumpkin>
In-Reply-To: <BN7PR02MB414887B3CA73281177406A5BD4CCA@BN7PR02MB4148.namprd02.prod.outlook.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
	<1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
	<SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
	<5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
	<SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
	<6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
	<SN6PR02MB4157212C49D6A6E2AFE0CAA9D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
	<SN6PR02MB4157F236604B6780327E6B43D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
	<yk3ku4ud35rsrfwzvuqnrcnwogwngqlmc3otxrnoqefb47ajm7@orl5gcxuwrme>
	<BN7PR02MB414887B3CA73281177406A5BD4CCA@BN7PR02MB4148.namprd02.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Nov 2025 04:32:02 +0000
Michael Kelley <mhklinux@outlook.com> wrote:

> From: Josh Poimboeuf <jpoimboe@kernel.org> Sent: Tuesday, November 11, 20=
25 8:04 PM
> >=20
> > On Wed, Nov 12, 2025 at 02:26:18AM +0000, Michael Kelley wrote: =20
> > > > I've been able to debug this.  Two problems:
> > > >
> > > > 1) On Ubuntu (both 20.04 and 24.04), /bin/sh and /usr/bin/sh are sy=
mlinks
> > > > to "dash" (not "bash"). So the "shell" command in "make" invokes da=
sh. The
> > > > man page for dash shows that the built-in echo command accepts only=
 -n as
> > > > an option. The -e behavior of processing "\n" and similar sequences=
 is always
> > > > enabled. So on my Ubuntu systems, the "-e" is ignored by echo and b=
ecomes
> > > > part of the C source code sent to gcc, and of course it barfs. Drop=
ping the -e
> > > > makes it work for me (and the \n is handled correctly), but that mi=
ght not work
> > > > with other shells. Using "/bin/echo" with the -e solves the problem=
 in a more
> > > > compatible way across different shells. =20
> >=20
> > Ah.  I think we can use "printf" here.

Much better than echo - and a bultin on most shells.

> >  =20
> > > > 2) With make v4.2.1 on my Ubuntu 20.04 system, the "#" character in=
 the
> > > > "#include" added to the echo command is problematic. "make" seems t=
o be
> > > > treating it as a comment character, though I'm not 100% sure of that
> > > > interpretation. Regardless, the "#" causes a syntax error in the "m=
ake" shell
> > > > command. Adding a backslash before the "#" solves that problem. On =
an Ubuntu
> > > > 24.04 system with make v4.3, the "#" does not cause any problems. (=
I tried to put
> > > > make 4.3 on my Ubuntu 20.04 system, but ran into library compatibil=
ity problems
> > > > so I wasn=E2=80=99t able to definitively confirm that it is the mak=
e version that changes the
> > > > handling of the "#"). Unfortunately, adding the backslash before th=
e # does *not*
> > > > work with make v4.3. The backslash becomes part of the C source cod=
e sent to
> > > > gcc, which barfs. I don't immediately have a suggestion on how to r=
esolve this
> > > > in a way that is compatible across make versions. =20
> > >
> > > Using "\043" instead of the "#" is a compatible solution that works i=
n make
> > > v4.2.1 and v4.3 and presumably all other versions as well. =20
> >=20
> > Hm... I've seen similar portability issues with "," for which we had to
> > change it to "$(comma)" which magically worked for some reason that I am
> > forgetting.
> >=20
> > Does "$(pound)" work?  This seems to work here:

Please not 'pound' - that is the uk currency symbol (not what US greengroce=
rs
scrawl for lb).

	David

> >=20
> >         HAVE_XXHASH =3D $(shell printf "$(pound)include <xxhash.h>\nXXH=
3_state_t *state;int main() {}" | \
> >  =20
>=20
> Yes, the above line works in my Ubuntu 20.04 and 24.04 environments.
> It properly detects the presence and absence of xxhash 0.8. Seems like a
> good solution to me.
>=20
> Michael


