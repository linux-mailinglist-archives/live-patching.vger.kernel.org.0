Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509084A8CA2
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 20:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353792AbiBCTnV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Feb 2022 14:43:21 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:36426 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiBCTnU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Feb 2022 14:43:20 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F3FE91F399;
        Thu,  3 Feb 2022 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643917399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=djYBuNzUo5jlyYldd5YsGcxLff7fJbIGicD7buvtm2k=;
        b=NwM5TkfR1zyi/rgDW50fbTo0gTVrSMXizrc1Hdhka9rZBFsRiu1IrRdxGRLSj4edOVDiaC
        U4627lPy3D9aD6lTwPLKBYSjy1mDOQt7w/g2IzW7Mdz/Vz6arGUir9qfXv7vfY8ZS9SBZS
        EAC6fEiLmRag8QFr2rnW3PubGKi1LkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643917399;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=djYBuNzUo5jlyYldd5YsGcxLff7fJbIGicD7buvtm2k=;
        b=QGceBBfehFjsqNEjwXcVC31z3bq7/nzYuwVBDa0BISCQVByB2w4M478kVcehlHYQosR5FL
        QEnUNk5Norx3y0Cw==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A061FA3B81;
        Thu,  3 Feb 2022 19:43:18 +0000 (UTC)
Date:   Thu, 3 Feb 2022 20:43:17 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Aaron Tomlin <atomlin@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>, cl@linux.com,
        pmladek@suse.com, mbenes@suse.cz, akpm@linux-foundation.org,
        jeyu@kernel.org, linux-kernel@vger.kernel.org,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        atomlin@atomlin.com, ghalat@redhat.com, allen.lkml@gmail.com,
        void@manifault.com, joe@perches.com
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <20220203194317.GC3113@kunlun.suse.cz>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

On Wed, Feb 02, 2022 at 04:20:41PM -0800, Luis Chamberlain wrote:
> On Sun, Jan 30, 2022 at 09:32:01PM +0000, Aaron Tomlin wrote:
> > Hi Luis,
> > 
> > As per your suggestion [1], this is an attempt to refactor and split
> > optional code out of core module support code into separate components.
> > This version is based on branch mcgrof/modules-next since a97ac8cb24a3/or
> > modules-5.17-rc1. Please let me know your thoughts.
> > 
> > Changes since v1 [2]:
> 
> Thanks for all this work Aaron! Can you drop the RFC prefix,
> rebase onto linus' latest tree (as he already merged my
> modules-next, so his tree is more up to date), and submit again?
> 
> I'll then apply this to my modules-next, and then ask Christophe to
> rebase on top of that.
> 
> Michal, you'd be up next if you want to go through modules-next.

Sounds like a good idea. When rebasing on top of 5.17-rc1 the only
conflict was on the module code.

Thanks

Michal
