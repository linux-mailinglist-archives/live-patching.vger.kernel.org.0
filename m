Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6299262199
	for <lists+live-patching@lfdr.de>; Tue,  8 Sep 2020 22:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgIHU7z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Sep 2020 16:59:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56788 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725997AbgIHU7y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Sep 2020 16:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599598793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QDxqJJtxikAk+TP8erWdser2zhhtAWwdtKyMtfuzbSY=;
        b=H1qNW6RK5GlNWvWpgmdopBK/M5ZCL5n61MfmWeEAqxMHfGj1w8DS3gydCaFHkdSX3+/Jke
        uwJW41BUqq8qu5cfUtBumFvaR5pyZEqqk7yRW3lSWDmjoA/IPzqAvsjzp1rJj2lP9zN2jq
        O/H2j6Ik+GsVyTntFkc2VULOjiKxMLw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-cNX-G96bOXm-dG0MkvF8ZA-1; Tue, 08 Sep 2020 16:59:51 -0400
X-MC-Unique: cNX-G96bOXm-dG0MkvF8ZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D320A8018A1;
        Tue,  8 Sep 2020 20:59:49 +0000 (UTC)
Received: from treble (ovpn-117-163.rdu2.redhat.com [10.10.117.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 561CE7EEAC;
        Tue,  8 Sep 2020 20:59:49 +0000 (UTC)
Date:   Tue, 8 Sep 2020 15:59:47 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [GIT PULL] livepatching for 5.9-rc5
Message-ID: <20200908205947.arryy75c5cvldps7@treble>
References: <20200907082036.GC8084@alley>
 <CAHk-=wiZUYjmPLiEaN5uHM4mGyYq8RBFvk=iZKkm9=8NxvcoZQ@mail.gmail.com>
 <20200908183239.vhy2txzcmlliul7d@treble>
 <CAHk-=wi==UJf0fWUGn6RhQ2hvLW7PA9Yj4GWaTJxa3roENAHDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wi==UJf0fWUGn6RhQ2hvLW7PA9Yj4GWaTJxa3roENAHDg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Sep 08, 2020 at 11:42:00AM -0700, Linus Torvalds wrote:
> On Tue, Sep 8, 2020 at 11:32 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > Can you share the .o file?  At least I can't recreate with GCC 9.3.1,
> > which is all I have at the moment.
> 
> Done off-list in private, because I don't think anybody else wants
> object files flying around on the mailing lists..

The problem is that objtool ignores handle_external_interrupt_irqoff()
(because it has the STACK_FRAME_NON_STANDARD annotation), and the
'ignore' logic is a bit crude.

Because that function is ignored, the tail call isn't detected (as you
pointed out).  Which confuses the static noreturn detection logic.

The proper fix would be to move that thunk call code to proper asm,
where we can add some unwind hints, and then get rid of the
STACK_FRAME_NON_STANDARD.

But, in the interest of being lazy, here's the easiest fix for now.
I'll need to run some builds to make sure it doesn't break anything.

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index e034a8f24f46..90a66891441a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -619,7 +619,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		if (!is_static_jump(insn))
 			continue;
 
-		if (insn->ignore || insn->offset == FAKE_JUMP_OFFSET)
+		if (insn->offset == FAKE_JUMP_OFFSET)
 			continue;
 
 		reloc = find_reloc_by_dest_range(file->elf, insn->sec,

