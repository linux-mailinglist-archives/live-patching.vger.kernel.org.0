Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1145D47E20B
	for <lists+live-patching@lfdr.de>; Thu, 23 Dec 2021 12:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347889AbhLWLIu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Dec 2021 06:08:50 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59946 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347895AbhLWLIq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Dec 2021 06:08:46 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 51CC221128;
        Thu, 23 Dec 2021 11:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640257725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LLyiXrFXVKmCxSGs1dhYd9u4D7SzC6X7urXbFh45ixw=;
        b=bFS7SZki+gGKtR2A4w1SniEtzRtthqAjszqfCI/sgYaIgp1I6Zs6wmR4JrDAqxV0/TXlmJ
        Hndl0mkXQvvAypsnLTLq5GfemLxkiv0ilH57tnjkF8CXXQMDuf2IdKnu1ZgGFXS9BU9Agb
        dJv+3wQMM70MUu566+bild2yacRadkg=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0D96FA3BAE;
        Thu, 23 Dec 2021 11:08:45 +0000 (UTC)
Date:   Thu, 23 Dec 2021 12:08:41 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v3] Documentation: livepatch: Add livepatch API page
Message-ID: <YcRYuW78jIU+VxIH@alley>
References: <20211221145743.4098360-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221145743.4098360-1-void@manifault.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2021-12-21 06:57:45, David Vernet wrote:
> The livepatch subsystem has several exported functions and objects with
> kerneldoc comments. Though the livepatch documentation contains handwritten
> descriptions of all of these exported functions, they are currently not
> pulled into the docs build using the kernel-doc directive.
> 
> In order to allow readers of the documentation to see the full kerneldoc
> comments in the generated documentation files, this change adds a new
> Documentation/livepatch/api.rst page which contains kernel-doc directives
> to link the kerneldoc comments directly in the documentation.  With this,
> all of the hand-written descriptions of the APIs now cross-reference the
> kerneldoc comments on the new Livepatching APIs page, and running
> ./scripts/find-unused-docs.sh on kernel/livepatch no longer shows any files
> as missing documentation.
> 
> Note that all of the handwritten API descriptions were left alone with the
> exception of Documentation/livepatch/system-state.rst, which was updated to
> allow the cross-referencing to work correctly. The file now follows the
> cross-referencing formatting guidance specified in
> Documentation/doc-guide/kernel-doc.rst. Furthermore, some comments around
> klp_shadow_free_all() were updated to say <_, id> rather than <*, id> to
> match the rest of the file, and to prevent the docs build from emitting an
> "Inline emphasis start-string without end string" error.
> 
> Signed-off-by: David Vernet <void@manifault.com>

JFYI, the patch has been committed into livepatch.git, branch
for-5.17/fixes.

Best Regards,
Petr
