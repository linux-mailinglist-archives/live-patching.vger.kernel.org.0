Return-Path: <live-patching+bounces-2885-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMTLCZs3FGpuKwcAu9opvQ
	(envelope-from <live-patching+bounces-2885-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 13:50:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD135CA2FF
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 13:50:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8730D3018ACD
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 11:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3844A37F748;
	Mon, 25 May 2026 11:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J7Vh3h8M"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833E61A23B1
	for <live-patching@vger.kernel.org>; Mon, 25 May 2026 11:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779709764; cv=none; b=uVR1TVTWf8S40UDYqu6VcGEVnTeV7wjjriZLz2leBxv50srz70SoUHchYmINWoMKqLZS1yKo+P9B0Qr1vF30JidRMIj0fyXjLOtxbOhCfJ1/ZIMjMGULQLJ3FOYvGRYjIZw70ttsC/J3i2KxI19aA2hR0eXCpdLIhzubnCM9gRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779709764; c=relaxed/simple;
	bh=KrxdAeLUhOdbTOeg6AjThXmoxH0Kuzb7+z3TySKZ5Ek=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hUl1MLEJ+wv/tbaiRPh6IpOXSso2cksxk3olQ4U83a7QsKuvOiCyzsaE7WWLCz0YQjjObFdqKExipiE0sogUycA9AOOGC/qINS5xNvEBl3BluTFJoAwH6O4SxQqwfZMx7YfkeCGDgTMJr9vPrX2N5D8JXV2K1NTQAyjGYkjMOcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J7Vh3h8M; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso58906285e9.1
        for <live-patching@vger.kernel.org>; Mon, 25 May 2026 04:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779709760; x=1780314560; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kdsBBlxH/fBT0qTKbx/OGQlMNoMysgVbWBk3JCaqZ+U=;
        b=J7Vh3h8MKk9Al5Rnl+JKHcLYApgCPEBlwf5UG8TV/UNVm9K+ntBRlng8nJ+sGAG0TP
         oAUTN7a7EExRm6XsBmqj/go/JVYPwSE7mQ+zVeHMMSeWz0kGzCzqyYMAX62DZxKQznYt
         zCVjJAFy4uSZ2TMHorHuzRbTji5tDLIj6ubSrSyaLWQOEkQByHURRVdVrKrnpzWFJicJ
         LwN5+ByUO5zgs2YWNLla5MTTwCoHFW50FVBNiVGEwK4SZXUyI1FcCV684XIF+bxWxuRG
         ueq1UEFDzF47pLQJuLCRUNpu4+FULATdqOIThXv10jmprUQ7XfsDWYoZzjs1B9TONoi3
         u1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779709760; x=1780314560;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdsBBlxH/fBT0qTKbx/OGQlMNoMysgVbWBk3JCaqZ+U=;
        b=IN+uGU39/ABDnC5j6d4u6E3M6pchZ4hqLQ6JAjys/AsUiJ3FAlk5YDlkkZy9O0d97w
         u6R9MpWg4NulNVvAogKOpXo4P9catnus7xxwmT9zKcbr2GPSLugafappw5GoE7DCSTet
         YY09vHPy3/jdp6S24hyJ7KwLTHmY+R5FxusX4C+tCGBc9tS/jLksv6VCBOiuYiqTfKfE
         xt8OI+bRpm7xKWlPwNidLKnCtPyRptA9OBIeIQwFcJJ3tE3LIrqBKF7pdNz+42dshsCt
         eRwxSj7oIWhmrArN3t9ycABwTohSf8jGY8FRKNRqEMGZHsiBhH9+E1ClFRY2XnGEVtI1
         gihw==
X-Forwarded-Encrypted: i=1; AFNElJ/hPgTVUgXvIXLjlxZhsirvUIvck6Lfk8Wb2+XqWrms4xVZP2Px+jQly0Uhi3iJBBTE+b6W5Njnx56PNLLe@vger.kernel.org
X-Gm-Message-State: AOJu0YxcffZ9Uz3JqydPeJELJhpRrnAGIcaQ//PubwX94ENvMNbTluMI
	orMnAMsnN7dR7zpUwkYNqaybwgU9baElAn9BKyIsLJVHlIpeQdEvU/YzfHYf2us8Zc0=
X-Gm-Gg: Acq92OGOBUX6QZaPo0FAtbUfuFp05xfTRgDy5oZiVm63H2xu5LjF6SAWKqzIWlKqyU+
	EJx+JT6Pz4iWIrS5iyQ+iCzYLZU1MB4Uqs/Gn4af5hrMUDvs/jMrJkbvAru3nlPd5/QROZsZYTw
	zERtp6ZixKYM9f/xzp8j2/+/RnwZjktBAENfUrSfvzlw1mdNfGmiA5uGhq47APDKPycdo4iUqpA
	w0vc343c4nNsz80EbjP5ZaRksH71en9jvHEwMTXj3X3CUZiSynbrdpCvtAAvsVfB4y4nxOVL51R
	1uxcRhc4oF/4e3v22Ht7UzzVIqu/SI7RbzJi5yR8FGGvBp5/Dfd4mnnl2UlLtH1e8z8G1MAOti3
	B6Fbk1ILbj3t+brpjdgQyjVPPnMa+6inzYBnNc3uML8O7z/aLgLeI/rSAnGDBIYYXGhTinFti4o
	3kzCp7HzoF6mxVrmb6qiTkgHWZws/KDxvihOzohCCmWp/7cyzTRQFzmKwZrp5V92IAGPc=
X-Received: by 2002:a05:600c:1c21:b0:490:44eb:c1ea with SMTP id 5b1f17b1804b1-49044ebc2edmr234633755e9.24.1779709759832;
        Mon, 25 May 2026 04:49:19 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49041781fc4sm120310185e9.1.2026.05.25.04.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 04:49:19 -0700 (PDT)
Message-ID: <d329f22e75fd01f2250490e4cba87f064a726f52.camel@suse.com>
Subject: Re: [PATCH 1/4] selftests: livepatch: Introduce _remove_mod function
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: sashiko-reviews@lists.linux.dev, Jiri Kosina <jikos@kernel.org>, Petr
 Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Shuah
 Khan <shuah@kernel.org>,  Miroslav Benes	 <mbenes@suse.cz>, Josh Poimboeuf
 <jpoimboe@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	live-patching@vger.kernel.org
Date: Mon, 25 May 2026 08:49:10 -0300
In-Reply-To: <20260524235906.267EF1F000E9@smtp.kernel.org>
References: <20260524-livepatch-unload-on-fail-v1-1-7465de7f741d@suse.com>
	 <20260524235906.267EF1F000E9@smtp.kernel.org>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2885-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 7DD135CA2FF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, 2026-05-24 at 23:59 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [Medium] `_remove_mod` uses `die()` which will terminate the script
> during cleanup operations.
> --
>=20
> commit 7b1591f4e5c3b351136e7fe2821eb2e15ae59ad0
> Author: Marcos Paulo de Souza <mpdesouza@suse.com>
>=20
> selftests: livepatch: Introduce _remove_mod function
>=20
> This commit introduces the _remove_mod internal function to remove a
> loaded
> module, intended to be used during cleanup when a testcase fails. It
> also
> refactors unload_mod to use this new helper function.
>=20
> > diff --git a/tools/testing/selftests/livepatch/functions.sh
> > b/tools/testing/selftests/livepatch/functions.sh
> > index 2bc50271729c6..3ec0b7962fc5c 100644
> > --- a/tools/testing/selftests/livepatch/functions.sh
> > +++ b/tools/testing/selftests/livepatch/functions.sh
>=20
> [ ... ]
>=20
> > @@ -241,9 +241,10 @@ function load_failing_mod() {
> > =C2=A0	log "$ret"
> > =C2=A0}
> > =C2=A0
> > -# unload_mod(modname) - unload a kernel module
> > +# _remove_mod(modname) - Internal function to remove a loaded
> > module.
> > +#=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Use u=
nload_mod() instead, which also
> > updates TEST_MODS tracking.
> > =C2=A0#	modname - module name to unload
> > -function unload_mod() {
> > +function _remove_mod() {
> > =C2=A0	local mod=3D"$1"
> > =C2=A0
> > =C2=A0	# Wait for module reference count to clear ...
> > @@ -261,6 +262,14 @@ function unload_mod() {
> > =C2=A0		die "failed to unload module $mod (/sys/module)"
>=20
> [Severity: Medium]
> The commit message notes this function will be used to remove loaded
> modules
> when a testcase fails. If used in a cleanup path (such as a bash EXIT
> trap),
> will calling die() here terminate the script prematurely?
>=20
> If a module fails to unload (for example, if its refcount doesn't
> drop),
> die() executes exit 1. Inside a trap, this aborts the rest of the
> cleanup process. This could skip unloading any remaining modules and
> prevent final cleanup operations like pop_config() from running,
> potentially
> leaving kernel tracing persistently enabled and polluting the system
> state
> for subsequent tests.

The system is already polluted when a testcase fails nowadays, since a
module is kept loaded either way, making the next tests to fail if they
also try to lead the same modules.

The current approach is trying to make it more reliable.

>=20
> > =C2=A0}
>=20
> [ ... ]

