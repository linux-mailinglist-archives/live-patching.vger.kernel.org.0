Return-Path: <live-patching+bounces-4-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EF77A9AA9
	for <lists+live-patching@lfdr.de>; Thu, 21 Sep 2023 20:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB5DE28222D
	for <lists+live-patching@lfdr.de>; Thu, 21 Sep 2023 18:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5EC18041;
	Thu, 21 Sep 2023 17:49:19 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32BE182D2
	for <live-patching@vger.kernel.org>; Thu, 21 Sep 2023 17:49:15 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B3D8BD25;
	Thu, 21 Sep 2023 10:41:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 3597E338AD;
	Thu, 21 Sep 2023 10:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1695292382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Js1zpV1/5tyHr20INs8L7sC4PojIEf8avVZr3ovZtM=;
	b=kmnRhCS9M0QXPtX1OhDAV3Y6l/pa1Pf+cx8XBXHzVcqRqVppnoYl8lDjYbqXemFVhBta93
	g7wNEKMNHZ/6Jgh58uPFoVTjG5v0WeyzrOhE9KTPXO7ea114eMDNExMkTiCvW7kSgEnPYY
	1HMq4IqDhyEtX7laXgnRERz03en9Jgw=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 3405F2C14E;
	Thu, 21 Sep 2023 10:33:00 +0000 (UTC)
Date: Thu, 21 Sep 2023 12:33:00 +0200
From: Petr Mladek <pmladek@suse.com>
To: "Leizhen (ThunderTown)" <thunder.leizhen@huaweicloud.com>
Cc: Yonghong Song <yonghong.song@linux.dev>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Song Liu <song@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Fangrui Song <maskray@google.com>, kernel-team@fb.com,
	Leizhen <thunder.leizhen@huawei.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, kernel test robot <oliver.sang@intel.com>,
	live-patching@vger.kernel.org
Subject: Re: [PATCH] kallsyms: Fix kallsyms_selftest failure
Message-ID: <ZQwb3NiOEkqHtrnD@alley>
References: <20230825034659.1037627-1-yonghong.song@linux.dev>
 <95a7d98c-b227-7929-b833-f6adc3b7e3ca@huaweicloud.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95a7d98c-b227-7929-b833-f6adc3b7e3ca@huaweicloud.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Adding live-patching list into Cc.

On Fri 2023-08-25 15:19:10, Leizhen (ThunderTown) wrote:
> On 2023/8/25 11:46, Yonghong Song wrote:
> > Kernel test robot reported a kallsyms_test failure when clang lto is
> > enabled (thin or full) and CONFIG_KALLSYMS_SELFTEST is also enabled.
> > I can reproduce in my local environment with the following error message
> > with thin lto:
> >   [    1.877897] kallsyms_selftest: Test for 1750th symbol failed: (tsc_cs_mark_unstable) addr=ffffffff81038090
> >   [    1.877901] kallsyms_selftest: abort
> > 
> > It appears that commit 8cc32a9bbf29 ("kallsyms: strip LTO-only suffixes
> > from promoted global functions") caused the failure. Commit 8cc32a9bbf29
> > changed cleanup_symbol_name() based on ".llvm." instead of '.' where
> > ".llvm." is appended to a before-lto-optimization local symbol name.
> > We need to propagate such knowledge in kallsyms_selftest.c as well.
> > 
> > Further more, compare_symbol_name() in kallsyms.c needs change as well.
> > In scripts/kallsyms.c, kallsyms_names and kallsyms_seqs_of_names are used
> > to record symbol names themselves and index to symbol names respectively.
> > For example:
> >   kallsyms_names:
> >     ...
> >     __amd_smn_rw._entry       <== seq 1000
> >     __amd_smn_rw._entry.5     <== seq 1001
> >     __amd_smn_rw.llvm.<hash>  <== seq 1002
> >     ...
> > 
> > kallsyms_seqs_of_names are sorted based on cleanup_symbol_name() through, so
> > the order in kallsyms_seqs_of_names actually has
> > 
> >   index 1000:   seq 1002   <== __amd_smn_rw.llvm.<hash> (actual symbol comparison using '__amd_smn_rw')
> >   index 1001:   seq 1000   <== __amd_smn_rw._entry
> >   index 1002:   seq 1001   <== __amd_smn_rw._entry.5
> > 
> > Let us say at a particular point, at index 1000, symbol '__amd_smn_rw.llvm.<hash>'
> > is comparing to '__amd_smn_rw._entry' where '__amd_smn_rw._entry' is the one to
> > search e.g., with function kallsyms_on_each_match_symbol(). The current implementation
> > will find out '__amd_smn_rw._entry' is less than '__amd_smn_rw.llvm.<hash>' and
> > then continue to search e.g., index 999 and never found a match although the actual
> > index 1001 is a match.
> > 
> > To fix this issue, let us do cleanup_symbol_name() first and then do comparison.
> > In the above case, comparing '__amd_smn_rw' vs '__amd_smn_rw._entry' and
> > '__amd_smn_rw._entry' being greater than '__amd_smn_rw', the next comparison will
> > be > index 1000 and eventually index 1001 will be hit an a match is found.
> > 
> > For any symbols not having '.llvm.' substr, there is no functionality change
> > for compare_symbol_name().
> 
> Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>
> 
> > 
> > Fixes: 8cc32a9bbf29 ("kallsyms: strip LTO-only suffixes from promoted global functions")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202308232200.1c932a90-oliver.sang@intel.com
> > Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
> > ---
> >  kernel/kallsyms.c          | 17 +++++++----------
> >  kernel/kallsyms_selftest.c | 23 +----------------------
> >  2 files changed, 8 insertions(+), 32 deletions(-)
> > 
> > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > index 016d997131d4..e12d26c10dba 100644
> > --- a/kernel/kallsyms.c
> > +++ b/kernel/kallsyms.c
> > @@ -188,16 +188,13 @@ static bool cleanup_symbol_name(char *s)
> >  
> >  static int compare_symbol_name(const char *name, char *namebuf)
> >  {
> > -	int ret;
> > -
> > -	ret = strcmp(name, namebuf);
> > -	if (!ret)
> > -		return ret;
> > -
> > -	if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
> > -		return 0;
> > -
> > -	return ret;
> > +	/* The kallsyms_seqs_of_names is sorted based on names after
> > +	 * cleanup_symbol_name() (see scripts/kallsyms.c) if clang lto is enabled.
> > +	 * To ensure correct bisection in kallsyms_lookup_names(), do
> > +	 * cleanup_symbol_name(namebuf) before comparing name and namebuf.
> > +	 */
> > +	cleanup_symbol_name(namebuf);
> > +	return strcmp(name, namebuf);
> >  }

Hmm, I think that this is not the right fix.

The problem is that compare_symbol_name() does not longer allow
to match the full name of the extra .llwm. symbols.

I think that the problem is that the problem is that the symbols
are sorted using cleanup_symbol_name(). They should be sorted
by using the full name.

Note that the original compare_symbol_name() returned return value
when comparing the non-stripped name. It will work correctly when
the non-stripped names are sorted.

I believe that the correct fix is:

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 653b92f6d4c8..da1f8ae68999 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -339,25 +339,6 @@ static int symbol_absolute(const struct sym_entry *s)
 	return s->percpu_absolute;
 }
 
-static void cleanup_symbol_name(char *s)
-{
-	char *p;
-
-	/*
-	 * ASCII[.]   = 2e
-	 * ASCII[0-9] = 30,39
-	 * ASCII[A-Z] = 41,5a
-	 * ASCII[_]   = 5f
-	 * ASCII[a-z] = 61,7a
-	 *
-	 * As above, replacing the first '.' in ".llvm." with '\0' does not
-	 * affect the main sorting, but it helps us with subsorting.
-	 */
-	p = strstr(s, ".llvm.");
-	if (p)
-		*p = '\0';
-}
-
 static int compare_names(const void *a, const void *b)
 {
 	int ret;
@@ -533,10 +514,6 @@ static void write_src(void)
 		printf("\n");
 	}
 
-	if (lto_clang)
-		for (i = 0; i < table_cnt; i++)
-			cleanup_symbol_name((char *)table[i]->sym);
-
 	sort_symbols_by_name();
 	output_label("kallsyms_seqs_of_names");
 	for (i = 0; i < table_cnt; i++)


Unfortunately, I could not check it easily because I do not have any
experience with building kernel with C-lang.

Anyway, what do you think, please?

Best Regards,
Petr

