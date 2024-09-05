Return-Path: <live-patching+bounces-603-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AD696CD9D
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 06:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A9971F27AB1
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 04:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9D214EC4B;
	Thu,  5 Sep 2024 04:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCxPYOeP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C94147C86;
	Thu,  5 Sep 2024 04:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725509641; cv=none; b=l1nVMRKYEGcC4wILs5NJ6Tw4EA/So2x52+WjTIRvacboVuacJNeIGauRWfDQGKGW4WsKposi41Xa6R43ryi9Cr7Z/5J4F3UOVEt0ONJLXz2NGMAaFxFtOBbqTfp1//GzPOur0/GJB1+Mhx9RsuMq6NmQHk8LhStlQBc1b/nV5N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725509641; c=relaxed/simple;
	bh=f5t3PChzy1sVjF/jbtS1q5ILWClUmKNpi1KhJynZdrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iakyx80o3xr9doxROTmDQarp6AXKXlL1LfGrXeS392ICnLxuVrkXEMLH/npr1p8ptL3iKZUNBXW+TxqjhpmC5I610K0oP1Z8247PetK3pLe8ccmooRd43FcQk13T0d7hGWdjAzD11mV0r8HvOxzgNofF/Ru6snxdXp36xRaO1Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCxPYOeP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6409AC4CEC4;
	Thu,  5 Sep 2024 04:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725509640;
	bh=f5t3PChzy1sVjF/jbtS1q5ILWClUmKNpi1KhJynZdrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NCxPYOePdZiNGkstd2sW8YpWVvLf3IyLits/SotWATxNbTnnen/nitwjp/wNJhiDg
	 X6z9Je4wRaqDkY/visy4dHdrB9zloFg4UTWMmGqH1FjFHMzkeTZlwr9O5PZ8Mv/Dtv
	 l40e5Udwt9CM5Al6/9wM6ZQKbtPg+mQGLrv6DVXcJmJs9e2H/XnemPFwNVR3pveByl
	 YLIGOR3J2G/g26L/dd5gzmLnpouC3aCh0Ye6EftEa7tMdLUdAluqpkpOmKIYZQ1QGl
	 5VrclQ3RssUE4aj/HHGCsJ7Xl51sZi9IYE2UktjRVjbY1mxjY1bvM+FJ1GGXU2FeaI
	 lWywU8gEN+zIQ==
Date: Wed, 4 Sep 2024 21:13:58 -0700
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
Message-ID: <20240905041358.5vzb3rsklbvzx73e@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240904043034.jwy4v2y4wkinjqe4@treble>
 <CAPhsuW6+6S5qBGEvFfVh7M-_-FntL=Rk=OqZzvQjpZ6MyDhNuA@mail.gmail.com>
 <20240904063736.c7ru2k5o7x35o2vy@treble>
 <20240904070952.kkafz2w5m7wnhblh@treble>
 <CAPhsuW6gy-OzjYH2u7gPceuphybP8Q43J9YjeUpkWTh5DBFRSQ@mail.gmail.com>
 <20240904205949.2dfmw6f7tcnza3rw@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904205949.2dfmw6f7tcnza3rw@treble>

On Wed, Sep 04, 2024 at 01:59:51PM -0700, Josh Poimboeuf wrote:
> On Wed, Sep 04, 2024 at 01:23:55PM -0700, Song Liu wrote:
> > [ 7285.260195] livepatch: nothing to patch!

This seems to be tripping up on an awful hack I had for silencing
modpost warnings.  Apparently it doesn't work with your config.

Try the below.  You can ignore the modpost warnings for now:

  WARNING: modpost: "__stop_klp_objects" [/home/jpoimboe/git/linux/klp-tmp/out/livepatch.ko] undefined!
  WARNING: modpost: "__start_klp_objects" [/home/jpoimboe/git/linux/klp-tmp/out/livepatch.ko] undefined!

diff --git a/scripts/livepatch/module.c b/scripts/livepatch/module.c
index 101cabf6b2f1..7e4a8477231f 100644
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
+	if (!!nr_objs) {
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

