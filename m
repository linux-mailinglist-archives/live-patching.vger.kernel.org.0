Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E231AAE4B
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2020 18:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416026AbgDOQ30 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Apr 2020 12:29:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24228 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1416034AbgDOQ3W (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Apr 2020 12:29:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586968159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lirxC6OyLMe94Ytuu+eqjqHGME51p1BmVUJrMUdq9/E=;
        b=hx6Mkye4IXKeYF8x7DtisHWB6aV/huEL5rsW+pujDDFFgPmw7vT29PZ9GDY5wq+Jh2l6G5
        OAk4X9DL7vbIPUVKSwQWfSr6N8OkqTGmrOGnqBaVS7J4eDmelJhSDtbuVDMmU+UK11AMOb
        N0Xbz4av/5xiRfy86w0t6CsD8kwtegM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-DketKOtEM7S8wFzabwZf9A-1; Wed, 15 Apr 2020 12:29:15 -0400
X-MC-Unique: DketKOtEM7S8wFzabwZf9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 178B919057A0;
        Wed, 15 Apr 2020 16:29:14 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63A465D9E2;
        Wed, 15 Apr 2020 16:29:13 +0000 (UTC)
Date:   Wed, 15 Apr 2020 11:29:11 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 1/7] livepatch: Apply vmlinux-specific KLP relocations
 early
Message-ID: <20200415162911.k3kuqi5dqmngise7@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <8c3af42719fe0add37605ede634c7035a90f9acc.1586881704.git.jpoimboe@redhat.com>
 <20200414174406.GC2483@worktop.programming.kicks-ass.net>
 <20200414180109.da4v2b4ifpixuzn3@treble>
 <20200414193150.iqw224itgpedpltm@treble>
 <alpine.LSU.2.21.2004151627100.13470@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2004151627100.13470@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Apr 15, 2020 at 04:30:15PM +0200, Miroslav Benes wrote:
> > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > Subject: [PATCH] livepatch: Disallow vmlinux.ko
> > 
> > This is purely a theoretical issue, but if there were a module named
> 
> OT: "if there were"... subjunctive?

I had to google "subjunctive", but yes that seems to be it :-)

It means "if, hypothetically, a module named vmlinux.ko existed"...

> > vmlinux.ko, the livepatch relocation code wouldn't be able to
> > distinguish between vmlinux-specific and vmlinux.o-specific KLP
> > relocations.
> > 
> > If CONFIG_LIVEPATCH is enabled, don't allow a module named vmlinux.ko.
> 
> Yup, there is no such check nowadays. I always struggle to find the right 
> balance between being overprotective and letting the user shoot themselves 
> in their foot if they want to. But it does not hurt, so ack to that.

Yeah, and it does seem very unlikely to have a vmlinux.ko, but
especially OOT modules do some crazy things and you never know...

-- 
Josh

