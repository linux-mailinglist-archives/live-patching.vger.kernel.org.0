Return-Path: <live-patching+bounces-1962-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6D8lDZHsgGleCAMAu9opvQ
	(envelope-from <live-patching+bounces-1962-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 19:27:29 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D98F3D0287
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 19:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BD08A303BA78
	for <lists+live-patching@lfdr.de>; Mon,  2 Feb 2026 18:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69022F7AD2;
	Mon,  2 Feb 2026 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmJjILq8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27BE2EFDA2;
	Mon,  2 Feb 2026 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770056818; cv=none; b=cIOX9uz+bdwm9HD5YLXN1dO67mT0pIzsrdeB6bYDN29R3rk9iuJtlxA97gnNde2wU7h/0Omb63HthCPQE3PfUXO3aPB5hZAL6dzlmVtgljbD2tZju2Run84chGDCxLEEPycEliBHFBdT6YTMlvHT34sUSCoIHG0g2lyLgS4uwq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770056818; c=relaxed/simple;
	bh=yxHcyu6QcQjBZXIHRn7cwJuXZRbWiEkyzwxtRkXe30s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8fXj9r2y7pZehe4WaAlxvudOifywCCY6o8oy2hgOgQaSYRsTqyW5NJwzt1UoLvaihC9hZAvcrAiujOnJlfN0UA8GAGdMQRn+yEiTVWMIEBGA6+YYFtMLAOkTQ3ENewuRB/LMQXgxzbDBfK3FWI+MRxxZIV5MJ5xeAg5LmbB6qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmJjILq8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91105C19425;
	Mon,  2 Feb 2026 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770056818;
	bh=yxHcyu6QcQjBZXIHRn7cwJuXZRbWiEkyzwxtRkXe30s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmJjILq8+IaKXWKSVRmGq5VaQ37HJeZimdJVpvYaVhGW/xNKCcR3qZ6vevhcwf8vJ
	 Sc7bOdg15EcRdagLxdP84LUyNx5Eu2koVNDhCvNGulo9QFTa/m0VZsZR7xCJzOEpTY
	 flR/8I+KaaBg6WfZAqtPLUR5gWBnRpeXzGlpr7YB6cGAb4qDuui7034q69c9JhT9Bi
	 4SLZqFUL8/mR5YzIrDXj8TH+J6AF+6E/ERRxhgdFMQ5eJ4fLDJKBI3Qg/jiReexOuG
	 sF0HVC6dIuMDsh2nyVr3iczNKhclFYZrD9xFWLwWU20GLQ99xW6NJhw05hsCUO/trV
	 P0K79wF0hjV0g==
Date: Mon, 2 Feb 2026 10:26:55 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: objtool: static_call: can't find static_call_key symbol:
 __SCK__WARN_trap
Message-ID: <anqjpt3izscwmbxmomuyrdkuqktk6gtmr7ucsvrt3ye6dfbufc@lifwnafr73pf>
References: <99f7cfd4-ef1a-4da6-842f-19429b1fb2d2@app.fastmail.com>
 <dbbcybceshl7xlj2qujmo6s2vha7oqvp6bqcir5jfjae7h2z7b@iy4uzb2ygunj>
 <puebtzhzzstmcdufv3deh2twxflheqf6b6opkmw4rfjfua67ns@gbkkboyglhpt>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <puebtzhzzstmcdufv3deh2twxflheqf6b6opkmw4rfjfua67ns@gbkkboyglhpt>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1962-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D98F3D0287
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 10:20:15AM -0800, Josh Poimboeuf wrote:
> On Mon, Feb 02, 2026 at 10:19:33AM -0800, Josh Poimboeuf wrote:
> > On Mon, Feb 02, 2026 at 05:18:13PM +0100, Arnd Bergmann wrote:
> > > Hi,
> > > 
> > > I see a new objtool related build failure on current linux-next
> > > with clang-21:
> > > 
> > > samples/livepatch/livepatch-shadow-fix1.o: error: objtool: static_call: can't find static_call_key symbol: __SCK__WARN_trap
> > > 
> > > I couldn't figure out what exactly is going on there, this seems fine
> > > with gcc, and so far only one of hundreds of configs has this issue.
> > > 
> > > See the attachments for .config and the object file.
> > 
> > Ah, this is CONFIG_MEM_ALLOC_PROFILING_DEBUG inserting a WARN() in the
> > sample livepatch module's memory allocation, triggering the following
> > warning (file->klp is true):
> > 
> > 		if (!key_sym) {
> > 			if (!opts.module || file->klp) {
> > 				ERROR("static_call: can't find static_call_key symbol: %s", tmp);
> > 				return -1;
> > 			}
> > 
> > 
> > So this is showing that the sample livepatch modules (which are built
> > differently from the new klp-build way of building livepatch modules)
> > will fail to build when trying to access a non-exported static key.
> 
> Erm, non-exported static *call*.

So I think we can just remove that file->klp check.  That check is
perhaps a bit too strict since it doesn't take into account livepatch
modules that were built without klp-build.

-- 
Josh

