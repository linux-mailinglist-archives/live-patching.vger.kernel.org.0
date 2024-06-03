Return-Path: <live-patching+bounces-313-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B415F8D87F0
	for <lists+live-patching@lfdr.de>; Mon,  3 Jun 2024 19:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D75591C22074
	for <lists+live-patching@lfdr.de>; Mon,  3 Jun 2024 17:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93F0137777;
	Mon,  3 Jun 2024 17:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bxCSfKUK"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCE11369A0
	for <live-patching@vger.kernel.org>; Mon,  3 Jun 2024 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435813; cv=none; b=tMXrJJAZUTTK3JBBYOlIzv6yOhgewbXJPgC9/DsV5oLRp2CDCl3JzsBG+foAz33vjtYNWvFHg9iGBMqRDIJVOy0GfSN0AL7/Di/3utQz5UOTCDDaJ3RC4yLiqruTx/eukVrT5yiXDFb6a65FcllWU23Q+mM019hyH6AcX39WZHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435813; c=relaxed/simple;
	bh=ltV8MMFtkwHdGR/la1V/bsd2+BUGbuIdSZO4QGmrCZw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gIKWfsVoIGFi9pn863vYOLz7kFgLAPjndZJPbnEFC+e9Ra08JR3Y0p/20g+MFPT3fRmPDAF5MUuuxi+yeQyPbr4moZkT0R9awWM/0KlMO9IJDVdz6lcyVYujZwqOr3+Xzi6raJLfg9lnGi4Jxs4bq8sPZQmNPwnM82w9+y8hOnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bxCSfKUK; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2e73359b979so43563181fa.1
        for <live-patching@vger.kernel.org>; Mon, 03 Jun 2024 10:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717435809; x=1718040609; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TP8+QiasuhOdVisljDp2pyOsuEXVypgBBteRkvvRnmM=;
        b=bxCSfKUKUW5FSAQV/Rz25JjXNjFpaCOZ5j7V8nbso+Pg4QlA5FE3sAyJAv8TI6nS2e
         HSqCd6iB71oYpqmdx3FZyv5DySEJf8DI2idMHvFfvJ6Xpi+zounoB2RJu4Oco6+U34yB
         LLK4O9MGTPGUKbv+gihRUPbsKkBMtaD6T3E5nTrkqslSWh6uTL3Oztt4N9kXD4WWmnSZ
         yDVeIPxPLz0W7BijJtubklvA6f9r1KLK9xZJV/vbpVSoGkwSo6FP7K7FXmofRst1i5gn
         Zy3nOxRiEbozgoxhKVPl8saxKPONml8/Vs5gUU76oZ5p0kiexiQFUBLDwKeplg1CiKXO
         UN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717435809; x=1718040609;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TP8+QiasuhOdVisljDp2pyOsuEXVypgBBteRkvvRnmM=;
        b=CyHE0Bh9PCkdUQWX2cKKfVL1Sictb7zb2B1AQcKUebJNWjI9PKAtPeL1y/yKbJ01nM
         eKC1/v4Gc/CVw4xKF23+EHufkDJ81VRbXpDKBvj1OvLnYRhxDP9mQM+0tXt+HL+RHxim
         5QfXrVMqZtmGhbOU7IHCdTRVnEISrIJwQS8ER7Ku8NZKLnF+XjAzQcnGK5EyS/P9ZeOo
         2fEG1Pqf7mXwcO2M8yIDqwdDWt0OHUL8/Eo6ZUZsy8/Z4QO18i8Yd2rk2c6beg8tZ4nV
         Y3Yc9NfZMQnxGgiTj6RncdE+IqRK3F1gstNxyXqVCy4smyBFdMTwXEL1Nbxqj/zuEFOp
         n/Dw==
X-Forwarded-Encrypted: i=1; AJvYcCXvBPz3/9DNdBikYn77lVsKD1JKnvOtTiA5mGd70W3AughL0+zzLupmW3l9++6jDKTS7YnXDazUwtA8iclw2AoXtN/3wUKLvzGRc9RPfA==
X-Gm-Message-State: AOJu0Yy99YxeGVe2HbZ39sKgDjeutySnY/cvPv9/F57XLuaWYQl6mZ4A
	lc65DgL7mMezV4A4Itct6ZykNiu23cWoPN712w8dBCdx5+4BDMPBoS9lXM0Yi4E=
X-Google-Smtp-Source: AGHT+IE+0wd2FALmz+YEky48ulSljh0Cpqs4+7FYshp7DkFopbgjBfjwqMaPji3bjfHN+riRsojTTQ==
X-Received: by 2002:a05:651c:1504:b0:2ea:b956:db2b with SMTP id 38308e7fff4ca-2eab956e51amr9894891fa.7.1717435808755;
        Mon, 03 Jun 2024 10:30:08 -0700 (PDT)
Received: from ?IPv6:2804:5078:851:4000:58f2:fc97:371f:2? ([2804:5078:851:4000:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242c247b0sm5738852b3a.216.2024.06.03.10.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 10:30:08 -0700 (PDT)
Message-ID: <3092cdf003427c6be942d2b8fa0671c084f8ebd9.camel@suse.com>
Subject: Re: [PATCH v2] selftests: livepatch: Test atomic replace against
 multiple modules
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>,  Jiri Kosina <jikos@kernel.org>, Miroslav Benes
 <mbenes@suse.cz>, Shuah Khan <shuah@kernel.org>, 
 live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2024 14:29:55 -0300
In-Reply-To: <Zl28ne_laBawq-KP@pathway.suse.cz>
References: <20240525-lp-atomic-replace-v2-1-142199bb65a1@suse.com>
	 <ZloormpDnnc4SDub@redhat.com>
	 <92d683bd138a76e6c7100f4984be202dd06c9424.camel@suse.com>
	 <Zl28ne_laBawq-KP@pathway.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-06-03 at 14:52 +0200, Petr Mladek wrote:
> On Fri 2024-05-31 18:06:48, Marcos Paulo de Souza wrote:
> > On Fri, 2024-05-31 at 15:44 -0400, Joe Lawrence wrote:
> > > On Sat, May 25, 2024 at 11:34:08AM -0300, Marcos Paulo de Souza
> > > wrote:
> > > > Adapt the current test-livepatch.sh script to account the
> > > > number of
> > > > applied livepatches and ensure that an atomic replace livepatch
> > > > disables
> > > > all previously applied livepatches.
> > > >=20
> > > > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > > > ---
> > > > Changes since v1:
> > > > * Added checks in the existing test-livepatch.sh instead of
> > > > creating a
> > > > =C2=A0 new test file. (Joe)
> > > > * Fixed issues reported by ShellCheck (Joe)
> > > > ---
> > > > =C2=A0.../testing/selftests/livepatch/test-livepatch.sh=C2=A0 | 46
> > > > ++++++++++++++++++++--
> > > > =C2=A01 file changed, 42 insertions(+), 4 deletions(-)
> > > >=20
> > > > diff --git a/tools/testing/selftests/livepatch/test-
> > > > livepatch.sh
> > > > b/tools/testing/selftests/livepatch/test-livepatch.sh
> > > > index e3455a6b1158..d85405d18e54 100755
> > > > --- a/tools/testing/selftests/livepatch/test-livepatch.sh
> > > > +++ b/tools/testing/selftests/livepatch/test-livepatch.sh
> > > > @@ -107,9 +107,12 @@ livepatch: '$MOD_LIVEPATCH': unpatching
> > > > complete
> > > > =C2=A0
> > > > =C2=A0# - load a livepatch that modifies the output from
> > > > /proc/cmdline
> > > > and
> > > > =C2=A0#=C2=A0=C2=A0 verify correct behavior
> > > > -# - load an atomic replace livepatch and verify that only the
> > > > second is active
> > > > -# - remove the first livepatch and verify that the atomic
> > > > replace
> > > > livepatch
> > > > -#=C2=A0=C2=A0 is still active
> > > > +# - load two addtional livepatches and check the number of
> > > > livepatch modules
> > > > +#=C2=A0=C2=A0 applied
> > > > +# - load an atomic replace livepatch and check that the other
> > > > three modules were
> > > > +#=C2=A0=C2=A0 disabled
> > > > +# - remove all livepatches besides the atomic replace one and
> > > > verify that the
> > > > +#=C2=A0=C2=A0 atomic replace livepatch is still active
> > > > =C2=A0# - remove the atomic replace livepatch and verify that none
> > > > are
> > > > active
> > > > =C2=A0
> > > > =C2=A0start_test "atomic replace livepatch"
> > > > @@ -119,12 +122,31 @@ load_lp $MOD_LIVEPATCH
> > > > =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> > > > =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> > > > =C2=A0
> > > > +for mod in test_klp_syscall test_klp_callbacks_demo; do
> > >=20
> > > Slightly nitpicky here, but the tests were originally written
> > > with
> > > the
> > > livepatch module names via variables like $MOD_LIVEPATCH.=C2=A0 Would
> > > using
> > > $MOD_LIVEPATCH{1,2,3} help indicate that their specifics aren't
> > > really
> > > interesting, that we just need 3 of them?
> >=20
> > Makes sense. I thought about it when I was changing the code, but I
> > didn't want to change it too much, so it was the result. But that
> > makes
> > sense to have the modules better named.
>=20
> I like this.
>=20
> > > > +	load_lp $mod
> > > > +done
> > > > +
> > > > +mods=3D(/sys/kernel/livepatch/*)
> > > > +nmods=3D${#mods[@]}
> > > > +if [ "$nmods" -ne 3 ]; then
> > > > +	die "Expecting three modules listed, found $nmods"
> > > > +fi
> > > > +
> > >=20
> > > I was going to suggest that we might protect against a situation
> > > where
> > > other livepatch modules were active, that a simple count wouldn't
> > > be
> > > sufficient.=C2=A0 But then I thought about this test, atomic replace!
> > > Anything previously loaded is going to be pushed aside anyway.
> > >=20
> > > So maybe (in another patch or set) it would be worth enhancing
> > > functions.sh :: start_test() do a quick sanity check to see that
> > > the
> > > initial conditions are safe?=C2=A0 That might also prevent some
> > > collateral
> > > damage when test A fails and leaves the world a strange place for
> > > tests
> > > B, C, etc.
> >=20
> > We have been discussing about start/end functions that would check
> > for
> > leftover modules... maybe should be a good think to implement soon
> > as
> > we land more tests.
>=20
> Makes sense :-)
>=20
> > > > =C2=A0load_lp $MOD_REPLACE replace=3D1
> > > > =C2=A0
> > > > =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> > > > =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> > > > =C2=A0
> > > > -unload_lp $MOD_LIVEPATCH
> > > > +mods=3D(/sys/kernel/livepatch/*)
> > > > +nmods=3D${#mods[@]}
> > > > +if [ "$nmods" -ne 1 ]; then
> > > > +	die "Expecting only one moduled listed, found $nmods"
> > > > +fi
> > > > +
> > > > +# These modules were disabled by the atomic replace
> > > > +for mod in test_klp_callbacks_demo test_klp_syscall
> > > > $MOD_LIVEPATCH; do
> > > > +	unload_lp "$mod"
> > > > +done
> > > > =C2=A0
> > > > =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> > > > =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> > > > @@ -142,6 +164,20 @@ livepatch: '$MOD_LIVEPATCH': starting
> > > > patching
> > > > transition
> > > > =C2=A0livepatch: '$MOD_LIVEPATCH': completing patching transition
> > > > =C2=A0livepatch: '$MOD_LIVEPATCH': patching complete
> > > > =C2=A0$MOD_LIVEPATCH: this has been live patched
> > > > +% insmod test_modules/test_klp_syscall.ko
> > >=20
> > > Similar minor nit here, too.=C2=A0 If we think copy/pasting all the
> > > $MOD_FOO
> > > is annoying, I am fine with leaving this as is.=C2=A0 I don't have a
> > > strong
> > > opinion other than following some convention.
> > >=20
> > > With that, I'm happy to ack as-is or with variable names.
> >=20
> > Thanks Joe! I think that is Petr's call, either way I can rework
> > this
> > patch, or send additional ones to adjust the tests.
>=20
> I would prefer if you did respin this patch. The use of
> $MOD_LIVEPATCH{1,2,3} would make even the patch easier to follow.

Done in v3. About the pre-check, I discussed with Miroslav about having
an easier way to skip tests. The idea was to split each "test" into a
different file, like fstests already does. Using this approach, each
start_test function will be placed in a different file to test
specifically one functionality. This way we can skip a test if we don't
have some requirements (like a sysfs attribute for example, or the
there were leftover modules).

I plan to send a patch starting this move when the v3 of this patchset
is accepted.

>=20
> Best Regards,
> Petr


