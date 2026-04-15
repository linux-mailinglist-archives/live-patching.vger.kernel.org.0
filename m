Return-Path: <live-patching+bounces-2356-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGrPCK+G32nSUgAAu9opvQ
	(envelope-from <live-patching+bounces-2356-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 14:38:07 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 880A340454A
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 14:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3576030711A9
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 12:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088CA2DC334;
	Wed, 15 Apr 2026 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NihDecWh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6F92D7812
	for <live-patching@vger.kernel.org>; Wed, 15 Apr 2026 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776256659; cv=none; b=g9Yi0wrnecceeSAeUx+G0YW1usKfGearT6ofO1OXmBQHHsOkiU9latNdFhnuUR38CWN+80WDUjUP+qGRBnDAE4sU2c1HqDwqDlBsYf49TF47OFyN4m3TY1iqCgVUHVwpuwBE5msQciRPeBLA6HA+E/qJBZuTdGA6J1Tj9f7NjZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776256659; c=relaxed/simple;
	bh=q4znQqg8V/w+XTKKS6TQ22baPgvBcP185doNB6m/8Eo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NLsQnbZUPDHUM4BZQHqQsBQGVTPon2AflXcN5MC2Mx3stjur4Msmb3TlcphhkKDv82u24Lci210Mu+hmgR1tOVwCc4R1KzXSaHiWgZenyXEN3MVvngHpODqYfqjo3FAzqDmmo91JB5owPCoilN3xP8SR3he5V0rATNhmySloHuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NihDecWh; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d572f7437so4280431f8f.1
        for <live-patching@vger.kernel.org>; Wed, 15 Apr 2026 05:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776256657; x=1776861457; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q4znQqg8V/w+XTKKS6TQ22baPgvBcP185doNB6m/8Eo=;
        b=NihDecWh8FInuI7hc8thR0MnAL7IO4TfE264DqxkIk2aVjd9p6syUlUo+eXPbtCirt
         Y9L8qbqYdiuCBEm1ogRjSLxjA8LGMdfDEuH81yuY+RF8NrIWblgXVNvrnzLsVB4mgCLl
         JM1znEpBMRxcyLSbzRxXAz4nafxqbWXIZcCSn1DjvmLKPMmDU+9yzEI7Z2Xv9eLrmwyO
         krl3I4FqOjL8MerTRG4fAlgOPYCWaZ0M58COpqaZy3OEfiDv8Jeytdto4cn+6seJu4eP
         igBFgSYv+B5G9zPQkoGo3CwfrG/k8zWHR5l89if+ljkdmhhYZT3xhMEKxyfJzK55T9eM
         kedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776256657; x=1776861457;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4znQqg8V/w+XTKKS6TQ22baPgvBcP185doNB6m/8Eo=;
        b=sNCCmrGalNK5LFs9k0OQj2eysYIT4vBIJhpvKrEf0Ay1tKUA/SLlbKLbbPtVufY13P
         TB2fiRt9UYKMTRCtC2p7gJKrEd/YU4ebPapGypAevMWl4p8aAZbSonYKvlZRKWofE6tV
         1C7WFL84JTXe8V3fO7eic5g67CNr65WO/OkghPTQHlvlNbNRJbT+L/HIgNeCEYEGTEVe
         9UqKwi6DCivP8avaFwki0UJYtxKLBIja5Fry08XZA4sZECF7gwqZLoyXmqfeX4eE5np5
         JQWRXfXy3imhK0hDAwkP0byu0Wi1n5Kd0Bn/cV9qK9ysmenjsUalD+/9DlNSnStHfx8o
         GZTA==
X-Forwarded-Encrypted: i=1; AFNElJ+aPheWxn9RVZPEFvPr1KwzwdX707qvpdMJqSgyykvSOpgQXNjzgZiyGulgFc+C60F6cJuch0lUeNuuybVw@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0kyPHGbwuuydFaNwFBkPN/W8Hm9z/vgmCSouTQ04RJc+FUa1M
	Qvi3UjcUMdTGqageBuvkjyfE3hozBbs0Hna/e9kL92ZHRjmD54bJxMXzl4wlOtR0m6o=
X-Gm-Gg: AeBDietSeG9hvECDDpFW8KqU5T9IqqX8qq8keagzgFv+hyySKZ/qrrIs0hoYgQGUN9A
	QS+BJFvBQ7dIyKgIrKAHNvxYHn7Z3hYyHSqzGAX+w4pUgby5TxKcw5ZIgrhBPsDgHRbJbpN0OXD
	ckqPfUkHNF4F9uimYgvOsJC/gh3v0iFEadCFNcp7SsJg6sD5gu7K8bKs2QKcCdN60PJ5lFsN2P5
	R9N63/lh76HoWKwwlUKCkYKwCyCho32R9R53/AortRHE5Jz/O089lDZU6IPpyqef7iwvbIye/yd
	D1SxwcTpX4OR6PqMpdvt/3am/9XBNvSt3O+2vXAZEX6FMDnVfI8v8dE4zCc688K/cq95KkMI6GV
	8+3WEnd9HsbioHw/zSmYKrTr4NGR7vEZabf4+1Tc/4hgtrU6SNkM7xvdAAgFSPVooyiEUeplOuB
	xyXYvTdyHIEds+bJz4i/U+MsHBBgDN7TgCpJlFSMGvJXY7roZGwrfhNxPUYkwRVSrbVwk=
X-Received: by 2002:a05:6000:1004:b0:43d:7868:21db with SMTP id ffacd0b85a97d-43d786822b6mr12590363f8f.18.1776256656638;
        Wed, 15 Apr 2026 05:37:36 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead33d65asm5004581f8f.4.2026.04.15.05.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 05:37:36 -0700 (PDT)
Message-ID: <847de72350a1fe8bd765f2e5493b13e8bf7b2966.camel@suse.com>
Subject: Re: [PATCH v2 0/6] kselftests: livepatch: Adapt tests to be
 executed on 4.12 kernels
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>,
 Shuah Khan <shuah@kernel.org>, 	live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Wed, 15 Apr 2026 09:37:30 -0300
In-Reply-To: <alpine.LSU.2.21.2604151357350.1967@pobox.suse.cz>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
	 <alpine.LSU.2.21.2604151357350.1967@pobox.suse.cz>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (by Flathub.org) 
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2356-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 880A340454A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 2026-04-15 at 14:01 +0200, Miroslav Benes wrote:
> On Mon, 13 Apr 2026, Marcos Paulo de Souza wrote:
>=20
> > A new version of the patchset, with fewer patches now. Please take
> > a look!
> >=20
> > Original cover-letter:
> > These patches don't really change how the patches are run, just
> > skip
> > some tests on kernels that don't support a feature (like kprobe and
> > livepatched living together) or when a livepatch sysfs attribute is
> > missing.
> >=20
> > The last patch slightly adjusts check_result function to skip dmesg
> > messages on SLE kernels when a livepatch is removed.
> >=20
> > These patches are based on printk/for-next branch.
> >=20
> > Please review! Thanks!
> >=20
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
>=20
> Besides my comment for 1/6 and what Sashiko discovered, it looks good
> to=20
> me.
>=20
> However, please also take a look at brand new=20
> test_modules/test_klp_mod_target.c. It does not build on old kernels
> since=20
> they lack proc_create_single(). I think it should be covered in this
> patch=20
> set too.

I saw that yesterday as well, but I wanted to merge this series first.
I have plans to create a way to unregister the livepatches if something
fails, so we can continue to run the other tests. I was planning to fix
the test_klp_mod_target.c in the same patchset.

>=20
> Regards
> Miroslav

