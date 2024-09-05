Return-Path: <live-patching+bounces-605-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA0196D026
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 09:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D368281B2D
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 07:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F5C192D73;
	Thu,  5 Sep 2024 07:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agjg7FgL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418E615B541;
	Thu,  5 Sep 2024 07:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725520435; cv=none; b=hA1HHgd2klJkZSBTA5atl12zlUA8pXzYosTZ1u3ZBJ4LG5fl/gGGRH8QF8Cm7fVs41m81qITdD76dqn3+4RhbeuXASvSqYoVITZ9qdADZyB8Huwnd0E6/QA065t+uDYpibIa99cXlarvc9jedgMV7wSsFICnExwUvteq1yOuQAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725520435; c=relaxed/simple;
	bh=DHO/hY4aEHXLlMQVRT4UFjT7aL00upTo5hniaOsNdWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2oLEwVUbUxnXk/hjkemOyYYXKNcgaSW/EgxDii47y3yszxOuEtpTnKylwV7GWSMDGWHPJFW1rDG/+wOIQ2IS3i3jwc1aCgtFJQjcyCxn8qPhk9eRus/aKX2MjVVABHnHT9maBpycCmxlwTi6xg6mJbbF676sPGh2jUbtsSX4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agjg7FgL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62451C4CEC4;
	Thu,  5 Sep 2024 07:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725520434;
	bh=DHO/hY4aEHXLlMQVRT4UFjT7aL00upTo5hniaOsNdWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=agjg7FgLi6Z6lgts8ltyTkhG2Y8CaMM0C5N3Q/uB+jDnOOtyh8U7CEEuMtsBbIklB
	 qhO+//qDXz59Vl1j4VMYFMRWdoPaRcUNJHVCb9QU5i8dVZHf6pCOsjZZTI5GLL0DNw
	 +IX9IH3iiDWnh6jsBPgXV+v+kzHKfh31dg6XyUc5ORE/mH2tm2p0FTpIrKy5r4Rxit
	 oaFM5Jjj6BxJNncZ47VtvGPHCLJWV1hAKTaE/tQuqmwnmzw+8tNOUVAU7CJG6+n8+F
	 Sk59t4EZo6DhbY0fKpVnBBMFpVPAYpfkcw5pmKDKHKhjKEKdlWmZwMIOX6LpNcEKsJ
	 Ip6PJBOlHqujQ==
Date: Thu, 5 Sep 2024 00:13:52 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240905071352.shnm6pnjhdxa7yfl@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240904043034.jwy4v2y4wkinjqe4@treble>
 <CAPhsuW6+6S5qBGEvFfVh7M-_-FntL=Rk=OqZzvQjpZ6MyDhNuA@mail.gmail.com>
 <20240904063736.c7ru2k5o7x35o2vy@treble>
 <20240904070952.kkafz2w5m7wnhblh@treble>
 <CAPhsuW6gy-OzjYH2u7gPceuphybP8Q43J9YjeUpkWTh5DBFRSQ@mail.gmail.com>
 <20240904205949.2dfmw6f7tcnza3rw@treble>
 <20240905041358.5vzb3rsklbvzx73e@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240905041358.5vzb3rsklbvzx73e@treble>

On Wed, Sep 04, 2024 at 09:14:00PM -0700, Josh Poimboeuf wrote:

> +	if (!!nr_objs) {
            ^^
	    oops

Fixed version:

diff --git a/scripts/livepatch/module.c b/scripts/livepatch/module.c
index 101cabf6b2f1..2908999efa21 100644
--- a/scripts/livepatch/module.c
+++ b/scripts/livepatch/module.c
@@ -14,16 +14,13 @@
 // TODO livepatch could recognize these sections directly
 // TODO use function checksums instead of sympos
 
-extern char __start_klp_objects, __stop_klp_objects;
 
 /*
  * Create weak versions of the linker-created symbols to prevent modpost from
  * warning about unresolved symbols.
  */
-__weak char __start_klp_objects = 0;
-__weak char __stop_klp_objects  = 0;
-struct klp_object_ext *__start_objs = (struct klp_object_ext *)&__start_klp_objects;
-struct klp_object_ext *__stop_objs  = (struct klp_object_ext *)&__stop_klp_objects;
+extern struct klp_object_ext __start_klp_objects[];
+extern struct klp_object_ext __stop_klp_objects[];
 
 static struct klp_patch *patch;
 
@@ -33,9 +30,9 @@ static int __init livepatch_mod_init(void)
 	unsigned int nr_objs;
 	int ret;
 
-	nr_objs = __stop_objs - __start_objs;
+	nr_objs = __stop_klp_objects - __start_klp_objects;
 
-	if (!__start_klp_objects || !nr_objs) {
+	if (!nr_objs) {
 		pr_err("nothing to patch!\n");
 		ret = -EINVAL;
 		goto err;
@@ -54,7 +51,7 @@ static int __init livepatch_mod_init(void)
 	}
 
 	for (int i = 0; i < nr_objs; i++) {
-		struct klp_object_ext *obj_ext = __start_objs + i;
+		struct klp_object_ext *obj_ext = __start_klp_objects;
 		struct klp_func_ext *funcs_ext = obj_ext->funcs;
 		unsigned int nr_funcs = obj_ext->nr_funcs;
 		struct klp_func *funcs = objs[i].funcs;
@@ -105,7 +102,7 @@ static void __exit livepatch_mod_exit(void)
 {
 	unsigned int nr_objs;
 
-	nr_objs = __stop_objs - __start_objs;
+	nr_objs = __stop_klp_objects - __start_klp_objects;
 
 	for (int i = 0; i < nr_objs; i++)
 		kfree(patch->objs[i].funcs);
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f48d72d22dc2..20d0f03025b3 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1739,7 +1739,7 @@ static void check_exports(struct module *mod)
 		exp = find_symbol(s->name);
 		if (!exp) {
 			if (!s->weak && nr_unresolved++ < MAX_UNRESOLVED_REPORTS)
-				modpost_log(warn_unresolved ? LOG_WARN : LOG_ERROR,
+				modpost_log(LOG_WARN,
 					    "\"%s\" [%s.ko] undefined!\n",
 					    s->name, mod->name);
 			continue;


