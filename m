Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAFB259D1C
	for <lists+live-patching@lfdr.de>; Tue,  1 Sep 2020 19:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgIARZD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 1 Sep 2020 13:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgIARZA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 1 Sep 2020 13:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598981099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8PqT0EakorR2gsUjc/WrDrlcsD1OTR+SxQRxSKs2oGQ=;
        b=K6U6qqw4W5EXo36ba9g8GAtdfaWIE/2GIYq4DS0yhPjeMT9gHmIUoZiAeQEPcIemwi7mYk
        N/DPtrGEUCm3Fn4et3c8ED4XR59a7jax4qW3MbRmovEPpXWzto9VhYIDoO+51/p7YvbGUv
        iZAERVc/jQL+Ue75tXCKdUOrRg5D750=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-Ubgxi10CMnChTxIDXzvLyw-1; Tue, 01 Sep 2020 13:24:55 -0400
X-MC-Unique: Ubgxi10CMnChTxIDXzvLyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DD3810ABDB2;
        Tue,  1 Sep 2020 17:24:54 +0000 (UTC)
Received: from treble (ovpn-113-168.rdu2.redhat.com [10.10.113.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B97F95C1BB;
        Tue,  1 Sep 2020 17:24:53 +0000 (UTC)
Date:   Tue, 1 Sep 2020 12:24:51 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] Revert "kbuild: use -flive-patching when
 CONFIG_LIVEPATCH is enabled"
Message-ID: <20200901172451.uckohkruradfhd6g@treble>
References: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com>
 <alpine.LSU.2.21.2007211316410.31851@pobox.suse.cz>
 <20200806092426.GL24529@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200806092426.GL24529@alley>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Aug 06, 2020 at 11:24:26AM +0200, Petr Mladek wrote:
> On Tue 2020-07-21 13:17:00, Miroslav Benes wrote:
> > On Fri, 17 Jul 2020, Josh Poimboeuf wrote:
> > 
> > > Use of the new -flive-patching flag was introduced with the following
> > > commit:
> > > 
> > >   43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
> > > 
> > > This reverts commit 43bd3a95c98e1a86b8b55d97f745c224ecff02b9.
> > > 
> > > Fixes: 43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
> > > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > 
> > Acked-by: Miroslav Benes <mbenes@suse.cz>
> 
> Acked-by: Petr Mladek <pmladek@suse.com>
> 
> Hmm, the patch has not been pushed into livepatching.git and is not
> available in the pull request for 5.9.
> 
> Is it OK to leave it for 5.10?
> Or would you prefer to get it into 5.9 even on this stage?
> 
> I personally do not mind. It depends how urgent it is for others.

Sorry for leaving this question hanging.  Let's go with 5.10 ;-)

-- 
Josh

