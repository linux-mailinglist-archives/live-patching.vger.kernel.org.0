Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDB922A058
	for <lists+live-patching@lfdr.de>; Wed, 22 Jul 2020 21:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732552AbgGVT4Q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jul 2020 15:56:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:40083 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbgGVT4Q (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jul 2020 15:56:16 -0400
IronPort-SDR: i8mlJNivRn3tjIKkhlmSz3egI/kbAd+e6Yd/SpzDpmUZJlQFyM0cBneI7DseMjG+xGesO0tPx6
 2lR+219e+ccA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="138501878"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="138501878"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 12:56:15 -0700
IronPort-SDR: dp01G1YgXUZz1OxqW8lljzi0D0OzzYTa7bKaJ2Mo0oDFhpSjcg2Jrf8enws2LkIq4FTbEBDlrT
 fdd7QdYdtahw==
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="362820651"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.14.158])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 12:56:13 -0700
Message-ID: <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org
Date:   Wed, 22 Jul 2020 12:56:10 -0700
In-Reply-To: <202007221241.EBC2215A@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
         <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
         <202007220738.72F26D2480@keescook> <20200722160730.cfhcj4eisglnzolr@treble>
         <202007221241.EBC2215A@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 2020-07-22 at 12:42 -0700, Kees Cook wrote:
> On Wed, Jul 22, 2020 at 11:07:30AM -0500, Josh Poimboeuf wrote:
> > On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
> > > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > > > Let me CC live-patching ML, because from a quick glance this is
> > > > something 
> > > > which could impact live patching code. At least it invalidates
> > > > assumptions 
> > > > which "sympos" is based on.
> > > 
> > > In a quick skim, it looks like the symbol resolution is using
> > > kallsyms_on_each_symbol(), so I think this is safe? What's a good
> > > selftest for live-patching?
> > 
> > The problem is duplicate symbols.  If there are two static
> > functions
> > named 'foo' then livepatch needs a way to distinguish them.
> > 
> > Our current approach to that problem is "sympos".  We rely on the
> > fact
> > that the second foo() always comes after the first one in the
> > symbol
> > list and kallsyms.  So they're referred to as foo,1 and foo,2.
> 
> Ah. Fun. In that case, perhaps the LTO series has some solutions. I
> think builds with LTO end up renaming duplicate symbols like that, so
> it'll be back to being unique.
> 

Well, glad to hear there might be some precendence for how to solve
this, as I wasn't able to think of something reasonable off the top of
my head. Are you speaking of the Clang LTO series? 
https://lore.kernel.org/lkml/20200624203200.78870-1-samitolvanen@google.com/

