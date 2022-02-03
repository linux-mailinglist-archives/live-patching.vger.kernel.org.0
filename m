Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3754A8CF7
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 21:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349026AbiBCUKP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Feb 2022 15:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238986AbiBCUKO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Feb 2022 15:10:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DC7C061714;
        Thu,  3 Feb 2022 12:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zpQHkd2Xwed3B/yhMJC1nsWJsO1WsU38lPs21+hQc84=; b=qMuEqiay4sjEx5tB1bhFZBMvHP
        jRl8Nav6ArT3YSaK2RTfowp4y6WRzz7Ot7x+QFv/Al7LNExFhel6R0HQKtDqNzqTA7gXU/a9EN6eR
        XhedeSU86Cg8qc2bLGW+fiPV7mAvD6wXGUwBWvrk9X1jvRmvM5Gp+GbL0fGXwGFlz9halbshQzcXG
        DDPVNCDa3ZuRvC4R4XI+zijSn9X1tO2RhS3R2TdDeDNDDKABdrOsul/kmfZqLklCK7AHTbci6c3Zh
        01CNnMnDE+BVWNxNwMgZx+29DB6bpvBBJXMxZA08W8wNjj5ClDEKv+B2GCGI7Zy41wlMy74SUHVnU
        frK+YkuQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFiQg-002gcJ-EH; Thu, 03 Feb 2022 20:10:06 +0000
Date:   Thu, 3 Feb 2022 12:10:06 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Aaron Tomlin <atomlin@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michal Suchanek <msuchanek@suse.de>
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <Yfw2nm5X+8jRic0C@bombadil.infradead.org>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

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

Linus now merged the fix in question, just be sure to use his
latest tree, it should include 67d6212afda218d564890d1674bab28e8612170f

> I'll then apply this to my modules-next, and then ask Christophe to
> rebase on top of that.

If you can fix the issues from your patches which Christophe mentioned
that would be great. Then I'll apply then and then Christophe can work
off of that.

> Michal, you'd be up next if you want to go through modules-next.

  Luis
