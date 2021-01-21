Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D95B2FF285
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 18:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbhAURxb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 12:53:31 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:46904 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389071AbhAURqq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 12:46:46 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-7-70jJZbebO02FvmwaO8iuwQ-1;
 Thu, 21 Jan 2021 17:44:57 +0000
X-MC-Unique: 70jJZbebO02FvmwaO8iuwQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 21 Jan 2021 17:44:55 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 21 Jan 2021 17:44:55 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
CC:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        "Andrew Donnellan" <ajd@linux.ibm.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Joe Lawrence" <joe.lawrence@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jessica Yu <jeyu@kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Miroslav Benes <mbenes@suse.cz>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 02/13] module: add a module_loaded helper
Thread-Topic: [PATCH 02/13] module: add a module_loaded helper
Thread-Index: AQHW8BhvE0+Qt/OaHkK/jwqI2nu4BKoyViXg
Date:   Thu, 21 Jan 2021 17:44:55 +0000
Message-ID: <8d59f11971764db2a104c87937e1d3ab@AcuMS.aculab.com>
References: <20210121074959.313333-1-hch@lst.de>
 <20210121074959.313333-3-hch@lst.de>
 <844a7fc3-2cba-46d2-fd4e-e5fe16b08573@csgroup.eu>
 <20210121171119.GA29916@lst.de>
In-Reply-To: <20210121171119.GA29916@lst.de>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> 
> On Thu, Jan 21, 2021 at 11:00:20AM +0100, Christophe Leroy wrote:
> > > +bool module_loaded(const char *name);
> >
> > Maybe module_is_loaded() would be a better name.
> 
> Fine with me.

It does look like both callers aren't 'unsafe'.
But it is a bit strange returning a stale value.

It did make be look a bit more deeply at try_module_get().
For THIS_MODULE (eg to get an extra reference for a kthread)
I doubt it can ever fail.

But the other cases require a 'module' structure be passed in.
ISTM that unloading the module could invalidate the pointer
that has just been read from some other structure.

I'm guessing that some other lock must always be held.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

